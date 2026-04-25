<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>

  <#if section = "header">
    ${msg("doLogIn")}

  <#elseif section = "form">
    <form id="kc-otp-login-form" class="form-dark" action="${url.loginAction}" method="post">

      <#if otpLogin.userOtpCredentials?size gt 1>
        <div class="mb-3">
          <label class="form-label text-light">${msg("loginOtpOneTime")}</label>
          <#list otpLogin.userOtpCredentials as otpCredential>
            <div class="form-check">
              <input class="form-check-input" type="radio" id="kc-otp-credential-${otpCredential?index}"
                     name="selectedCredentialId" value="${otpCredential.id}"
                     <#if otpCredential.id = otpLogin.selectedCredentialId>checked</#if> />
              <label class="form-check-label text-light" for="kc-otp-credential-${otpCredential?index}">
                ${otpCredential.userLabel}
              </label>
            </div>
          </#list>
        </div>
      </#if>

      <div class="mb-3">
        <label class="form-label text-light" for="otp">${msg("loginOtpOneTime")}</label>
        <input type="text" id="otp" name="otp" autocomplete="one-time-code" inputmode="numeric" autofocus
               class="form-control <#if messagesPerField.existsError('totp')>is-invalid</#if>"
               aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" />
        <#if messagesPerField.existsError('totp')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('totp'))?no_esc}</div>
        </#if>
      </div>

      <div class="d-grid my-4">
        <button class="btn btn-primary" type="submit">${msg("doLogIn")}</button>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
