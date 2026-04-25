<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>

  <#if section = "header">
    ${msg("doLogIn")}

  <#elseif section = "form">
    <#if realm.password>
      <form id="kc-form-login" class="form-dark" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">

        <#if !usernameHidden??>
          <div class="mb-3">
            <label class="form-label text-light" for="username">
              <#if !realm.loginWithEmailAllowed>${msg("username")}
              <#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}
              <#else>${msg("email")}
              </#if>
            </label>
            <input tabindex="1"
                   id="username"
                   class="form-control <#if messagesPerField.existsError('username','password')>is-invalid</#if>"
                   name="username"
                   value="${(login.username!'')}"
                   type="text"
                   autofocus
                   autocomplete="username"
                   placeholder="${msg('username')}"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <#if messagesPerField.existsError('username','password')>
              <div class="invalid-feedback d-block" aria-live="polite">
                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
              </div>
            </#if>
          </div>
        </#if>

        <div class="mb-3">
          <label class="form-label text-light" for="password">${msg("password")}</label>
          <div class="input-group">
            <input tabindex="2"
                   id="password"
                   class="form-control <#if messagesPerField.existsError('username','password')>is-invalid</#if>"
                   name="password"
                   type="password"
                   autocomplete="current-password"
                   placeholder="${msg('password')}"
                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
            <button class="btn btn-outline-secondary" type="button"
                    onclick="(function(b){var i=document.getElementById('password');i.type=(i.type==='password'?'text':'password');b.querySelector('i').classList.toggle('fa-eye');b.querySelector('i').classList.toggle('fa-eye-slash');})(this)"
                    aria-label="${msg('showPassword')}">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>

        <div class="row mt-4">
          <div class="col">
            <#if realm.rememberMe && !usernameHidden??>
              <div class="form-check text-2">
                <input tabindex="3" id="rememberMe" name="rememberMe" class="form-check-input" type="checkbox" <#if login.rememberMe??>checked</#if>/>
                <label class="form-check-label text-light" for="rememberMe">${msg("rememberMe")}</label>
              </div>
            </#if>
          </div>
          <#if realm.resetPasswordAllowed>
            <div class="col-sm text-2 text-end">
              <a tabindex="5" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
            </div>
          </#if>
        </div>

        <div class="d-grid my-4">
          <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth?? && auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
          <button tabindex="4" class="btn btn-primary" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
        </div>
      </form>
    </#if>

  <#elseif section = "info">
    <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
      ${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a>
    </#if>
  </#if>

</@layout.registrationLayout>
