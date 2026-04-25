<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>

  <#if section = "header">
    ${msg("emailVerifyTitle")}

  <#elseif section = "form">
    <div class="text-center mb-4">
      <i class="fas fa-envelope-open-text text-primary" style="font-size:4rem"></i>
    </div>
    <p class="text-light text-center mb-3">${msg("emailVerifyInstruction1",user.email)}</p>
    <p class="text-white-50 text-center mb-4 text-2">${msg("emailVerifyInstruction2")} <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}</p>
  </#if>

</@layout.registrationLayout>
