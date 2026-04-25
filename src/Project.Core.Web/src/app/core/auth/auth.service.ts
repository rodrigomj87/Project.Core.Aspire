import { Injectable, inject } from '@angular/core';
import { OAuthService, AuthConfig } from 'angular-oauth2-oidc';
import { Router } from '@angular/router';
import { environment } from '../../../environments/environment';

const authConfig: AuthConfig = {
  issuer: environment.authority,
  redirectUri: window.location.origin + '/login-callback',
  clientId: 'projectcore-spa',
  responseType: 'code',
  scope: 'openid profile email offline_access projectcore_api.all',
  showDebugInformation: false,
  requireHttps: false,
  postLogoutRedirectUri: window.location.origin,
};

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly oauthService = inject(OAuthService);
  private readonly router = inject(Router);

  configure(): void {
    this.oauthService.configure(authConfig);
    this.oauthService.setupAutomaticSilentRefresh();
  }

  async initLoginFlow(): Promise<void> {
    await this.oauthService.loadDiscoveryDocumentAndTryLogin();
  }

  login(): void {
    this.oauthService.initCodeFlow();
  }

  logout(): void {
    this.oauthService.logOut();
  }

  get isLoggedIn(): boolean {
    return this.oauthService.hasValidAccessToken();
  }

  get accessToken(): string {
    return this.oauthService.getAccessToken();
  }

  get userName(): string {
    const claims = this.oauthService.getIdentityClaims() as Record<string, string> | null;
    return claims?.['name'] ?? claims?.['preferred_username'] ?? '';
  }
}
