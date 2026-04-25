import { Component, inject, signal } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs';
import { AuthService } from '../../core/auth/auth.service';

@Component({
  selector: 'app-app-shell',
  standalone: true,
  imports: [
    RouterOutlet, RouterLink, RouterLinkActive,
    MatSidenavModule, MatToolbarModule, MatButtonModule,
    MatIconModule, MatListModule, MatMenuModule,
  ],
  template: `
    <mat-sidenav-container class="shell-container">
      <mat-sidenav
        #sidenav
        [mode]="isMobile() ? 'over' : 'side'"
        [opened]="!isMobile()"
        class="shell-sidenav">
        <mat-nav-list>
          <a mat-list-item routerLink="/app/categories" routerLinkActive="active-link">
            <mat-icon matListItemIcon>category</mat-icon>
            <span i18n="@@nav.categories">Categorias</span>
          </a>
          <a mat-list-item routerLink="/app/items" routerLinkActive="active-link">
            <mat-icon matListItemIcon>inventory_2</mat-icon>
            <span i18n="@@nav.items">Itens</span>
          </a>
        </mat-nav-list>
      </mat-sidenav>

      <mat-sidenav-content>
        <mat-toolbar color="primary">
          <button mat-icon-button (click)="sidenav.toggle()">
            <mat-icon>menu</mat-icon>
          </button>
          <span i18n="@@app.name">Project Core</span>
          <span class="spacer"></span>
          <button mat-button [matMenuTriggerFor]="userMenu">
            <mat-icon>account_circle</mat-icon>
            {{ auth.userName }}
          </button>
          <mat-menu #userMenu="matMenu">
            <button mat-menu-item (click)="auth.logout()">
              <mat-icon>logout</mat-icon>
              <span i18n="@@nav.logout">Sair</span>
            </button>
          </mat-menu>
        </mat-toolbar>

        <div class="shell-content">
          <router-outlet />
        </div>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `,
  styles: [`
    .shell-container { height: 100vh; }
    .shell-sidenav { width: 220px; padding-top: 8px; }
    .spacer { flex: 1 1 auto; }
    .shell-content { padding: 24px; }
    .active-link { background: rgba(0,0,0,.08); font-weight: 600; }
  `],
})
export class AppShell {
  readonly auth = inject(AuthService);

  private readonly breakpointObserver = inject(BreakpointObserver);

  readonly isMobile = toSignal(
    this.breakpointObserver.observe(Breakpoints.Handset).pipe(map((r) => r.matches)),
    { initialValue: false }
  );
}
