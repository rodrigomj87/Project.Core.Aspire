<#import "template.ftl" as layout>
<@layout.registrationLayout displayRequiredFields=false displayMessage=!messagesPerField.existsError('totp','userLabel'); section>

  <#if section = "header">
    ${msg("loginTotpTitle")}

  <#elseif section = "form">
    <ol class="text-light text-2 mb-4">
      <li class="mb-2">
        ${msg("loginTotpStep1")}
        <ul class="list-unstyled small mt-1">
          <#list totp.supportedApplications as app>
            <li class="text-white-50">&bull; ${msg(app)}</li>
          </#list>
        </ul>
      </li>

      <#if mode?? && mode = "manual">
        <li class="mb-2">
          ${msg("loginTotpManualStep2")}
          <p class="text-white font-monospace bg-secondary bg-opacity-25 rounded p-2 mt-1">${totp.totpSecretEncoded}</p>
          <p class="text-2"><a href="${totp.qrUrl}">${msg("loginTotpScanBarcode")}</a></p>
        </li>
        <li class="mb-2">
          ${msg("loginTotpManualStep3")}
          <ul class="list-unstyled small mt-1 text-white-50">
            <li>${msg("loginTotpType")}: ${msg("loginTotp." + totp.policy.type)}</li>
            <li>${msg("loginTotpAlgorithm")}: ${totp.policy.algorithm}</li>
            <li>${msg("loginTotpDigits")}: ${totp.policy.digits}</li>
            <#if totp.policy.type = "totp">
              <li>${msg("loginTotpInterval")}: ${totp.policy.period}</li>
            <#else>
              <li>${msg("loginTotpCounter")}: ${totp.policy.initialCounter}</li>
            </#if>
          </ul>
        </li>
      <#else>
        <li class="mb-2">
          ${msg("loginTotpStep2")}
          <div class="text-center my-3"><img src="data:image/png;base64,${totp.totpSecretQrCode}" alt="QR code" /></div>
          <p class="text-2"><a href="${totp.manualUrl}">${msg("loginTotpUnableToScan")}</a></p>
        </li>
      </#if>

      <li>${msg("loginTotpStep3")}<br/>${msg("loginTotpStep3DeviceName")}</li>
    </ol>

    <form id="kc-totp-settings-form" class="form-dark" action="${url.loginAction}" method="post">
      <div class="mb-3">
        <label class="form-label text-light" for="totp">${msg("authenticatorCode")} <span class="text-danger">*</span></label>
        <input type="text" id="totp" name="totp" autocomplete="off" inputmode="numeric"
               class="form-control <#if messagesPerField.existsError('totp')>is-invalid</#if>"
               aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" />
        <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
        <#if mode??><input type="hidden" id="mode" value="${mode}" /></#if>
        <#if messagesPerField.existsError('totp')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('totp'))?no_esc}</div>
        </#if>
      </div>

      <div class="mb-3">
        <label class="form-label text-light" for="userLabel">${msg("loginTotpDeviceName")} <#if totp.otpCredentials?size gte 1><span class="text-danger">*</span></#if></label>
        <input type="text" id="userLabel" name="userLabel" autocomplete="off"
               class="form-control <#if messagesPerField.existsError('userLabel')>is-invalid</#if>"
               aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>" />
        <#if messagesPerField.existsError('userLabel')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('userLabel'))?no_esc}</div>
        </#if>
      </div>

      <input type="hidden" id="logout-sessions" name="logout-sessions" value="on" />

      <div class="d-grid gap-2 my-4">
        <button class="btn btn-primary" type="submit" name="submitAction" value="Save">${msg("doSubmit")}</button>
        <#if isAppInitiatedAction??>
          <button class="btn btn-outline-light" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </#if>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
