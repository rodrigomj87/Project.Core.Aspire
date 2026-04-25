<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>

  <#if section = "header">
    ${msg("errorTitle")}

  <#elseif section = "form">
    <div class="text-center mb-4">
      <i class="fas fa-exclamation-triangle text-danger" style="font-size:4rem"></i>
    </div>

    <p id="kc-error-message" class="text-light text-center mb-4">
      ${kcSanitize(message.summary)?no_esc}
    </p>

    <#if skipLink??>
    <#elseif client?? && client.baseUrl?has_content>
      <p class="text-center"><a class="btn btn-outline-light" id="backToApplication" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
    </#if>
  </#if>

</@layout.registrationLayout>
