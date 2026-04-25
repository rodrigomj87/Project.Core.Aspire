<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>

  <#if section = "header">
    <#if messageHeader??>${messageHeader}<#else>${message.summary}</#if>

  <#elseif section = "form">
    <div class="text-center mb-4">
      <i class="fas fa-info-circle text-info" style="font-size:4rem"></i>
    </div>

    <p class="text-light text-center mb-3">
      ${message.summary?no_esc}
      <#if requiredActions??>
        <#list requiredActions>: <#items as reqActionItem>${msg("requiredAction.${reqActionItem}")}<#sep>, </#items></#list>
      </#if>
    </p>

    <#if skipLink??>
    <#elseif pageRedirectUri?has_content>
      <p class="text-center"><a class="btn btn-outline-light" href="${pageRedirectUri}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
    <#elseif actionUri?has_content>
      <p class="text-center"><a class="btn btn-primary" href="${actionUri}">${kcSanitize(msg("proceedWithAction"))?no_esc}</a></p>
    <#elseif client?? && client.baseUrl?has_content>
      <p class="text-center"><a class="btn btn-outline-light" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
    </#if>
  </#if>

</@layout.registrationLayout>
