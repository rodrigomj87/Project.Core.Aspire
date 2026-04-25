import { Component, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { AuthService } from '../../core/auth/auth.service';

@Component({
  selector: 'app-public-shell',
  standalone: true,
  imports: [RouterOutlet, MatToolbarModule, MatButtonModule],
  template: `
    <mat-toolbar color="primary">
      <span i18n="@@app.name">Project Core</span>
      <span class="spacer"></span>
      <button mat-button (click)="auth.login()" i18n="@@nav.login">Entrar</button>
    </mat-toolbar>
    <main class="public-content">
      <router-outlet />
    </main>
  `,
  styles: [`
    .spacer { flex: 1 1 auto; }
    .public-content { padding: 24px; }
  `],
})
export class PublicShell {
  readonly auth = inject(AuthService);
}
