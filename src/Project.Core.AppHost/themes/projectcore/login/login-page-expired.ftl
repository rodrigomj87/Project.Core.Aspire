<#import "template.ftl" as layout>
<@layout.registrationLayout; section>

  <#if section = "header">
    ${msg("pageExpiredTitle")}

  <#elseif section = "form">
    <div class="text-center mb-4">
      <i class="fas fa-clock text-warning" style="font-size:4rem"></i>
    </div>
    <p class="text-light text-center mb-2">${msg("pageExpiredMsg1")} <a href="${url.loginRestartFlowUrl}">${msg("doClickHere")}</a></p>
    <p class="text-light text-center">${msg("pageExpiredMsg2")} <a href="${url.loginAction}">${msg("doClickHere")}</a></p>
  </#if>

</@layout.registrationLayout>
