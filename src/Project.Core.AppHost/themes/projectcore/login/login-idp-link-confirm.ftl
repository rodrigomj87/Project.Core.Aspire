<#import "template.ftl" as layout>
<@layout.registrationLayout; section>

  <#if section = "header">
    ${msg("confirmLinkIdpTitle")}

  <#elseif section = "form">
    <form id="kc-register-form" class="form-dark" action="${url.loginAction}" method="post">
      <div class="d-grid gap-2 my-4">
        <button type="submit" class="btn btn-outline-light" name="submitAction" id="updateProfile" value="updateProfile">${msg("confirmLinkIdpReviewProfile")}</button>
        <button type="submit" class="btn btn-primary" name="submitAction" id="linkAccount" value="linkAccount">${msg("confirmLinkIdpContinue", idpDisplayName)}</button>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
