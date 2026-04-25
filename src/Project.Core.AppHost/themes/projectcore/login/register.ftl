<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm') displayRequiredFields=true displayInfo=true; section>

  <#if section = "header">
    ${msg("registerTitle")}

  <#elseif section = "form">
    <form id="kc-register-form" class="form-dark" action="${url.registrationAction}" method="post">

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label text-light" for="firstName"><span class="text-danger">*</span> ${msg("firstName")}</label>
          <input type="text" id="firstName" class="form-control <#if messagesPerField.existsError('firstName')>is-invalid</#if>"
                 name="firstName" value="${(register.formData.firstName!'')}"
                 aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>" />
          <#if messagesPerField.existsError('firstName')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('firstName'))?no_esc}</div>
          </#if>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label text-light" for="lastName"><span class="text-danger">*</span> ${msg("lastName")}</label>
          <input type="text" id="lastName" class="form-control <#if messagesPerField.existsError('lastName')>is-invalid</#if>"
                 name="lastName" value="${(register.formData.lastName!'')}"
                 aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
          <#if messagesPerField.existsError('lastName')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('lastName'))?no_esc}</div>
          </#if>
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label text-light" for="email"><span class="text-danger">*</span> ${msg("email")}</label>
        <input type="email" id="email" class="form-control <#if messagesPerField.existsError('email')>is-invalid</#if>"
               name="email" value="${(register.formData.email!'')}" autocomplete="email"
               aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />
        <#if messagesPerField.existsError('email')>
          <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('email'))?no_esc}</div>
        </#if>
      </div>

      <#if !realm.registrationEmailAsUsername>
        <div class="mb-3">
          <label class="form-label text-light" for="username"><span class="text-danger">*</span> ${msg("username")}</label>
          <input type="text" id="username" class="form-control <#if messagesPerField.existsError('username')>is-invalid</#if>"
                 name="username" value="${(register.formData.username!'')}" autocomplete="username"
                 aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
          <#if messagesPerField.existsError('username')>
            <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('username'))?no_esc}</div>
          </#if>
        </div>
      </#if>

      <#if passwordRequired??>
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label text-light" for="password"><span class="text-danger">*</span> ${msg("password")}</label>
            <input type="password" id="password" class="form-control <#if messagesPerField.existsError('password','password-confirm')>is-invalid</#if>"
                   name="password" autocomplete="new-password"
                   aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>" />
            <#if messagesPerField.existsError('password')>
              <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('password'))?no_esc}</div>
            </#if>
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label text-light" for="password-confirm"><span class="text-danger">*</span> ${msg("passwordConfirm")}</label>
            <input type="password" id="password-confirm" class="form-control <#if messagesPerField.existsError('password-confirm')>is-invalid</#if>"
                   name="password-confirm" autocomplete="new-password"
                   aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
            <#if messagesPerField.existsError('password-confirm')>
              <div class="invalid-feedback d-block">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</div>
            </#if>
          </div>
        </div>
      </#if>

      <#if recaptchaRequired??>
        <div class="mb-3 d-flex justify-content-center">
          <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
        </div>
      </#if>

      <div class="d-grid my-4">
        <button class="btn btn-primary" type="submit">${msg("doRegister")}</button>
      </div>
    </form>

  <#elseif section = "info">
    ${msg("backToLogin")?no_esc} <a href="${url.loginUrl}">${msg("doLogIn")}</a>
  </#if>

</@layout.registrationLayout>
