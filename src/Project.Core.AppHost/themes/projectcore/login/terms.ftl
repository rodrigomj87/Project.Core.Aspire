<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>

  <#if section = "header">
    ${msg("termsTitle")}

  <#elseif section = "form">
    <div id="kc-terms-text" class="text-light text-2 mb-4" style="max-height:40vh;overflow-y:auto">
      ${kcSanitize(msg("termsText"))?no_esc}
    </div>

    <form class="form-dark" action="${url.loginAction}" method="post">
      <div class="d-grid gap-2 my-4">
        <button class="btn btn-primary" name="accept" id="kc-accept" type="submit">${msg("doAccept")}</button>
        <button class="btn btn-outline-light" name="cancel" id="kc-decline" type="submit">${msg("doDecline")}</button>
      </div>
    </form>
  </#if>

</@layout.registrationLayout>
