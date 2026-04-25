<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>

  <#if section = "header">
    ${msg("updatePasswordTitle")}

  <#elseif section = "form">
    <form id="kc-passwd-update-form" class="form-dark" action="${url.loginAction}" method="post">
      <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" hidden />
      <input type="password" id="password" name="password" autocomplete="current-password" hidden />

      <div class="mb-3">
        <label class="form-label text-light" for="password-new">${msg("passwordNew")}</label>
        <input type="password" id="password-new" name="password-new" autocomplete="new-password"
               class="form-control <#if messagesPerField.existsError('password')>is-invalid</#if>"
               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>" />
        <#if messagesPerField.existsError('password')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('password'))?no_esc}</div>
        </#if>
      </div>

      <div class="mb-3">
        <label class="form-label text-light" for="password-confirm">${msg("passwordConfirm")}</label>
        <input type="password" id="password-confirm" name="password-confirm" autocomplete="new-password"
               class="form-control <#if messagesPerField.existsError('password-confirm')>is-invalid</#if>"
               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
        <#if messagesPerField.existsError('password-confirm')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</div>
        </#if>
      </div>

      <#if isAppInitiatedAction??>
        <div class="form-check text-2 mb-3">
          <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" class="form-check-input" checked />
          <label class="form-check-label text-light" for="logout-sessions">${msg("logoutOtherSessions")}</label>
        </div>
      </#if>

      <div class="d-grid gap-2 my-4">
        <button class="btn btn-primary" type="submit">${msg("doSubmit")}</button>
        <#if isAppInitiatedAction??>
          <button class="btn btn-outline-light" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </#if>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
