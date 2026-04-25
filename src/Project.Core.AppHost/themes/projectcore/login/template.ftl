<#macro registrationLayout displayMessage=true displayRequiredFields=false displayWide=false showAnotherWayIfPresent=true displayInfo=false>
<!DOCTYPE html>
<html lang="${locale.currentLanguageTag}">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0, shrink-to-fit=no">
  <meta name="robots" content="noindex, nofollow">
  <title>${msg("loginTitle",(realm.displayName!''))}</title>
  <link rel="icon" href="${url.resourcesPath}/img/favicon.png" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700&display=swap" type="text/css" />

  <#if properties.styles?has_content>
    <#list properties.styles?split(' ') as style>
      <link rel="stylesheet" href="${url.resourcesPath}/${style}" type="text/css" />
    </#list>
  </#if>

  <#if properties.scripts?has_content>
    <#list properties.scripts?split(' ') as script>
      <script src="${url.resourcesPath}/${script}" type="text/javascript" defer></script>
    </#list>
  </#if>

  <#if scripts??>
    <#list scripts as script>
      <script src="${script}" type="text/javascript"></script>
    </#list>
  </#if>
</head>
<body class="oxyy-login-register bg-dark">

<#-- Per-page hero text falls back to generic keys when not provided -->
<#assign heroTitle = msg("heroTitle." + pageId!"login")!msg("heroTitle") />
<#assign heroSubtitle = msg("heroSubtitle." + pageId!"login")!msg("heroSubtitle") />

<div id="main-wrapper">
  <div class="container">
    <div class="row g-0 min-vh-100 py-4 py-md-5">

      <#-- Hero ============================================================= -->
      <div class="col-lg-7 shadow-lg order-2 order-lg-1">
        <div class="hero-wrap d-flex align-items-center rounded-3 rounded-lg-end-0 h-100">
          <div class="hero-mask opacity-9 bg-primary"></div>
          <div class="hero-bg hero-bg-scroll" style="background-image:url('${url.resourcesPath}/img/login-bg.jpg');"></div>
          <div class="hero-content mx-auto w-100 h-100 d-flex flex-column">
            <div class="row g-0">
              <div class="col-11 col-lg-10 mx-auto">
                <div class="logo mt-5 mb-5 mb-lg-0">
                  <a href="${url.loginUrl}" title="${realm.displayName!''}">
                    <img src="${url.resourcesPath}/img/logo-light.png" alt="${realm.displayName!''}">
                  </a>
                </div>
              </div>
            </div>
            <div class="row g-0 my-auto">
              <div class="col-11 col-lg-10 mx-auto">
                <h1 class="text-11 text-white mb-3">${heroTitle?no_esc}</h1>
                <p class="text-5 text-white lh-base mb-4">${heroSubtitle?no_esc}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <#-- Form ============================================================= -->
      <div data-bs-theme="dark" class="col-lg-5 shadow-lg d-flex align-items-center rounded-3 rounded-lg-start-0 bg-dark order-1 order-lg-2">
        <div class="container my-auto py-5">
          <div class="row">
            <div class="col-11 col-lg-10 mx-auto">

              <#-- Page title -->
              <h3 class="text-white text-center mb-4">
                <#nested "header">
              </h3>

              <#-- Locale switcher -->
              <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                <div class="d-flex justify-content-end mb-3">
                  <div class="dropdown">
                    <button class="btn btn-sm btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                      ${locale.current}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end">
                      <#list locale.supported as l>
                        <li><a class="dropdown-item" href="${l.url}">${l.label}</a></li>
                      </#list>
                    </ul>
                  </div>
                </div>
              </#if>

              <#-- Required fields hint -->
              <#if displayRequiredFields>
                <div class="text-2 text-white-50 text-end mb-2">
                  <span class="text-danger">*</span> ${msg("requiredFields")}
                </div>
              </#if>

              <#-- Global feedback message -->
              <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert alert-${(message.type = 'error')?then('danger', message.type)} alert-dismissible fade show" role="alert">
                  <#if message.type = 'success'><i class="fas fa-check-circle me-2"></i></#if>
                  <#if message.type = 'warning'><i class="fas fa-exclamation-triangle me-2"></i></#if>
                  <#if message.type = 'error'><i class="fas fa-times-circle me-2"></i></#if>
                  <#if message.type = 'info'><i class="fas fa-info-circle me-2"></i></#if>
                  <span class="kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                  <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
              </#if>

              <#-- Form body -->
              <#nested "form">

              <#-- "Try another way" link (during authentication) -->
              <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" class="text-center mt-3">
                  <input type="hidden" name="tryAnotherWay" value="on"/>
                  <a href="#" class="text-2 text-light"
                     onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">
                    ${msg("doTryAnotherWay")}
                  </a>
                </form>
              </#if>

              <#-- Social providers -->
              <#if realm.password?? && realm.password && social?? && social.providers?? && social.providers?has_content>
                <div class="d-flex align-items-center my-3">
                  <hr class="flex-grow-1 border-secondary">
                  <span class="mx-2 text-2 text-white-50">${msg("identity-provider-login-label")}</span>
                  <hr class="flex-grow-1 border-secondary">
                </div>
                <div class="d-flex flex-column align-items-center mb-4">
                  <ul class="social-icons social-icons-circle">
                    <#list social.providers as p>
                      <li class="social-icons-${p.alias}">
                        <a href="${p.loginUrl}" data-bs-toggle="tooltip" data-bs-original-title="${p.displayName!p.alias}">
                          <#if properties("kcLogoIdP-" + p.alias)?has_content>
                            <i class="${properties("kcLogoIdP-" + p.alias)}"></i>
                          <#else>
                            ${p.displayName!p.alias}
                          </#if>
                        </a>
                      </li>
                    </#list>
                  </ul>
                </div>
              </#if>

              <#-- Optional info section (e.g. "Sign In" link on register, "Sign Up" on login) -->
              <#if displayInfo>
                <div class="text-2 text-center text-light mt-3 mb-0">
                  <#nested "info">
                </div>
              </#if>

            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

</body>
</html>
</#macro>
