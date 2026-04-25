import { Component, inject, signal, OnInit } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatCardModule } from '@angular/material/card';
import { CategoryService } from '../../../core/services/category.service';
import { Category } from '../../../core/models/category.model';

@Component({
  selector: 'app-categories-list',
  standalone: true,
  imports: [MatTableModule, MatProgressBarModule, MatCardModule],
  template: `
    <h2 i18n="@@categories.title">Categorias</h2>

    @if (loading()) {
      <mat-progress-bar mode="indeterminate" />
    }

    <mat-card>
      <table mat-table [dataSource]="categories()" class="full-width">
        <ng-container matColumnDef="name">
          <th mat-header-cell *matHeaderCellDef i18n="@@categories.col.name">Nome</th>
          <td mat-cell *matCellDef="let row">{{ row.name }}</td>
        </ng-container>

        <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
        <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>

        @if (!loading() && categories().length === 0) {
          <tr class="mat-row">
            <td class="mat-cell empty-row" colspan="1" i18n="@@categories.empty">
              Nenhuma categoria encontrada.
            </td>
          </tr>
        }
      </table>
    </mat-card>
  `,
  styles: [`
    .full-width { width: 100%; }
    .empty-row { text-align: center; padding: 24px; }
    h2 { margin-bottom: 16px; }
  `],
})
export class CategoriesList implements OnInit {
  private readonly categoryService = inject(CategoryService);

  readonly categories = signal<Category[]>([]);
  readonly loading = signal(false);
  readonly displayedColumns = ['name'];

  ngOnInit(): void {
    this.loading.set(true);
    this.categoryService.getAll().subscribe({
      next: (data) => {
        this.categories.set(data);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }
}
