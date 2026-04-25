<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username') displayInfo=true; section>

  <#if section = "header">
    ${msg("emailForgotTitle")}

  <#elseif section = "form">
    <p class="text-white-50 text-center mb-4">${msg("emailInstruction")}</p>

    <form id="kc-reset-password-form" class="form-dark" action="${url.loginAction}" method="post">
      <div class="mb-3">
        <label class="form-label text-light" for="username">
          <#if !realm.loginWithEmailAllowed>${msg("username")}
          <#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}
          <#else>${msg("email")}
          </#if>
        </label>
        <input type="text" id="username" name="username"
               class="form-control <#if messagesPerField.existsError('username')>is-invalid</#if>"
               autofocus value="${(auth.attemptedUsername!'')}"
               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
        <#if messagesPerField.existsError('username')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('username'))?no_esc}</div>
        </#if>
      </div>

      <div class="d-grid my-4">
        <button class="btn btn-primary" type="submit">${msg("doSubmit")}</button>
      </div>
    </form>

  <#elseif section = "info">
    ${msg("backToLogin")?no_esc} <a href="${url.loginUrl}">${msg("doLogIn")}</a>
  </#if>

</@layout.registrationLayout>
