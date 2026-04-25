import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { AuthService } from '../../../core/auth/auth.service';

interface StackCard {
  icon: string;
  title: string;
  description: string;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [MatButtonModule, MatCardModule, MatIconModule],
  template: `
    <section class="hero">
      <h1 i18n="@@home.hero.title">.NET Backend Blueprint</h1>
      <p i18n="@@home.hero.subtitle">
        Template completo com .NET 10, Aspire, Clean Architecture, Keycloak e Angular.
      </p>
      <button mat-raised-button color="primary" (click)="login()" i18n="@@home.cta.login">
        Acessar o sistema
      </button>
    </section>

    <section class="cards">
      @for (card of stackCards; track card.title) {
        <mat-card class="stack-card">
          <mat-card-header>
            <mat-icon mat-card-avatar>{{ card.icon }}</mat-icon>
            <mat-card-title>{{ card.title }}</mat-card-title>
          </mat-card-header>
          <mat-card-content>
            <p>{{ card.description }}</p>
          </mat-card-content>
        </mat-card>
      }
    </section>
  `,
  styles: [`
    .hero {
      text-align: center;
      padding: 64px 24px 48px;
    }
    .hero h1 { font-size: 2.5rem; margin-bottom: 16px; }
    .hero p { font-size: 1.125rem; margin-bottom: 32px; color: #555; }
    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 24px;
      max-width: 1000px;
      margin: 0 auto;
      padding: 0 24px 48px;
    }
    .stack-card mat-icon { font-size: 32px; color: #1976d2; }
  `],
})
export class Home {
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  readonly stackCards: StackCard[] = [
    {
      icon: 'cloud',
      title: '.NET Aspire',
      description: $localize`:@@home.card.aspire:Orquestração local e deploy Azure com Container Apps e Flexible Server.`,
    },
    {
      icon: 'layers',
      title: 'Clean Architecture',
      description: $localize`:@@home.card.clean:Vertical Slices com separação clara de Domain, Application e Infrastructure.`,
    },
    {
      icon: 'security',
      title: 'Keycloak',
      description: $localize`:@@home.card.keycloak:Autenticação OIDC com PKCE, gerenciamento de usuários e roles.`,
    },
    {
      icon: 'web',
      title: 'Angular 21',
      description: $localize`:@@home.card.angular:Frontend standalone com Angular Material, signals e OIDC integrado.`,
    },
  ];

  login(): void {
    if (this.auth.isLoggedIn) {
      this.router.navigate(['/app']);
    } else {
      this.auth.login();
    }
  }
}
