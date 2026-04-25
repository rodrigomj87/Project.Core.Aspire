<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','firstName','lastName','email'); section>

  <#if section = "header">
    ${msg("loginProfileTitle")}

  <#elseif section = "form">
    <form id="kc-update-profile-form" class="form-dark" action="${url.loginAction}" method="post">

      <#if user.editUsernameAllowed>
        <div class="mb-3">
          <label class="form-label text-light" for="username">${msg("username")}</label>
          <input type="text" id="username" name="username" value="${(user.username!'')}"
                 class="form-control <#if messagesPerField.existsError('username')>is-invalid</#if>" />
          <#if messagesPerField.existsError('username')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('username'))?no_esc}</div>
          </#if>
        </div>
      </#if>

      <div class="mb-3">
        <label class="form-label text-light" for="email">${msg("email")}</label>
        <input type="email" id="email" name="email" value="${(user.email!'')}" autocomplete="email"
               class="form-control <#if messagesPerField.existsError('email')>is-invalid</#if>" />
        <#if messagesPerField.existsError('email')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('email'))?no_esc}</div>
        </#if>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label text-light" for="firstName">${msg("firstName")}</label>
          <input type="text" id="firstName" name="firstName" value="${(user.firstName!'')}"
                 class="form-control <#if messagesPerField.existsError('firstName')>is-invalid</#if>" />
          <#if messagesPerField.existsError('firstName')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('firstName'))?no_esc}</div>
          </#if>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label text-light" for="lastName">${msg("lastName")}</label>
          <input type="text" id="lastName" name="lastName" value="${(user.lastName!'')}"
                 class="form-control <#if messagesPerField.existsError('lastName')>is-invalid</#if>" />
          <#if messagesPerField.existsError('lastName')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('lastName'))?no_esc}</div>
          </#if>
        </div>
      </div>

      <div class="d-grid gap-2 my-4">
        <button class="btn btn-primary" type="submit">${msg("doSubmit")}</button>
        <#if isAppInitiatedAction??>
          <button class="btn btn-outline-light" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
        </#if>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
