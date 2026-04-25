import { Routes } from '@angular/router';
import { authGuard } from './core/auth/auth.guard';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./layout/public-shell/public-shell').then((m) => m.PublicShell),
    children: [
      { path: '', redirectTo: 'home', pathMatch: 'full' },
      {
        path: 'home',
        loadComponent: () =>
          import('./features/public/home/home').then((m) => m.Home),
      },
      { path: 'login-callback', redirectTo: 'home' },
    ],
  },
  {
    path: 'app',
    loadComponent: () =>
      import('./layout/app-shell/app-shell').then((m) => m.AppShell),
    canActivate: [authGuard],
    children: [
      { path: '', redirectTo: 'categories', pathMatch: 'full' },
      {
        path: 'categories',
        loadComponent: () =>
          import('./features/categories/list/categories-list').then(
            (m) => m.CategoriesList
          ),
      },
      {
        path: 'items',
        loadComponent: () =>
          import('./features/items/list/items-list').then((m) => m.ItemsList),
      },
      {
        path: 'items/new',
        loadComponent: () =>
          import('./features/items/form/item-form').then((m) => m.ItemForm),
      },
      {
        path: 'items/:id/edit',
        loadComponent: () =>
          import('./features/items/form/item-form').then((m) => m.ItemForm),
      },
    ],
  },
  { path: '**', redirectTo: 'home' },
];

