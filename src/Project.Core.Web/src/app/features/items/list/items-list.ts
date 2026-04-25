import { Component, inject, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { DecimalPipe } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatCardModule } from '@angular/material/card';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ItemService } from '../../../core/services/item.service';
import { ItemSummary, ItemsPage } from '../../../core/models/item.model';
import { DeleteConfirmDialog } from '../delete-confirm/delete-confirm-dialog';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-items-list',
  standalone: true,
  imports: [
    FormsModule,
    DecimalPipe,
    MatTableModule, MatPaginatorModule, MatButtonModule,
    MatIconModule, MatInputModule, MatFormFieldModule,
    MatProgressBarModule, MatCardModule, MatTooltipModule,
  ],
  template: `
    <div class="list-header">
      <h2 i18n="@@items.title">Itens</h2>
      <button mat-raised-button color="primary" (click)="newItem()">
        <mat-icon>add</mat-icon>
        <span i18n="@@items.btn.new">Novo Item</span>
      </button>
    </div>

    <mat-card class="search-card">
      <mat-form-field appearance="outline" class="search-field">
        <mat-label i18n="@@items.search.label">Buscar por nome</mat-label>
        <input matInput [(ngModel)]="searchName" (keyup.enter)="search()" />
        <button mat-icon-button matSuffix (click)="search()">
          <mat-icon>search</mat-icon>
        </button>
      </mat-form-field>
    </mat-card>

    @if (loading()) {
      <mat-progress-bar mode="indeterminate" />
    }

    <mat-card>
      <table mat-table [dataSource]="items()" class="full-width">
        <ng-container matColumnDef="name">
          <th mat-header-cell *matHeaderCellDef i18n="@@items.col.name">Nome</th>
          <td mat-cell *matCellDef="let row">{{ row.name }}</td>
        </ng-container>

        <ng-container matColumnDef="category">
          <th mat-header-cell *matHeaderCellDef i18n="@@items.col.category">Categoria</th>
          <td mat-cell *matCellDef="let row">{{ row.category }}</td>
        </ng-container>

        <ng-container matColumnDef="price">
          <th mat-header-cell *matHeaderCellDef i18n="@@items.col.price">Preço</th>
          <td mat-cell *matCellDef="let row">{{ row.price | number:'1.2-2' }}</td>
        </ng-container>

        <ng-container matColumnDef="releaseDate">
          <th mat-header-cell *matHeaderCellDef i18n="@@items.col.releaseDate">Lançamento</th>
          <td mat-cell *matCellDef="let row">{{ row.releaseDate }}</td>
        </ng-container>

        <ng-container matColumnDef="actions">
          <th mat-header-cell *matHeaderCellDef></th>
          <td mat-cell *matCellDef="let row" class="actions-cell">
            <button mat-icon-button color="primary" (click)="editItem(row)"
              matTooltip="Editar" i18n-matTooltip="@@items.btn.edit">
              <mat-icon>edit</mat-icon>
            </button>
            <button mat-icon-button color="warn" (click)="confirmDelete(row)"
              matTooltip="Excluir" i18n-matTooltip="@@items.btn.delete">
              <mat-icon>delete</mat-icon>
            </button>
          </td>
        </ng-container>

        <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
        <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>

        @if (!loading() && items().length === 0) {
          <tr class="mat-row">
            <td class="mat-cell empty-row" [attr.colspan]="displayedColumns.length"
              i18n="@@items.empty">
              Nenhum item encontrado.
            </td>
          </tr>
        }
      </table>

      <mat-paginator
        [length]="totalItems()"
        [pageSize]="pageSize"
        [pageSizeOptions]="[5, 10, 25]"
        (page)="onPage($event)"
        showFirstLastButtons />
    </mat-card>
  `,
  styles: [`
    .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
    .search-card { margin-bottom: 16px; padding: 16px; }
    .search-field { width: 100%; }
    .full-width { width: 100%; }
    .actions-cell { white-space: nowrap; }
    .empty-row { text-align: center; padding: 24px; }
  `],
})
export class ItemsList implements OnInit {
  private readonly itemService = inject(ItemService);
  private readonly router = inject(Router);
  private readonly dialog = inject(MatDialog);

  readonly items = signal<ItemSummary[]>([]);
  readonly loading = signal(false);
  readonly totalItems = signal(0);
  readonly displayedColumns = ['name', 'category', 'price', 'releaseDate', 'actions'];

  pageSize = 5;
  pageNumber = 1;
  searchName = '';

  ngOnInit(): void {
    this.loadPage();
  }

  search(): void {
    this.pageNumber = 1;
    this.loadPage();
  }

  onPage(event: PageEvent): void {
    this.pageNumber = event.pageIndex + 1;
    this.pageSize = event.pageSize;
    this.loadPage();
  }

  newItem(): void {
    this.router.navigate(['/app/items/new']);
  }

  editItem(item: ItemSummary): void {
    this.router.navigate(['/app/items', item.id, 'edit']);
  }

  confirmDelete(item: ItemSummary): void {
    const ref = this.dialog.open(DeleteConfirmDialog, {
      data: { name: item.name },
    });
    ref.afterClosed().subscribe((confirmed: boolean) => {
      if (confirmed) {
        this.itemService.delete(item.id).subscribe(() => this.loadPage());
      }
    });
  }

  private loadPage(): void {
    this.loading.set(true);
    this.itemService.getPage(this.pageNumber, this.pageSize, this.searchName || undefined).subscribe({
      next: (page: ItemsPage) => {
        this.items.set(page.data);
        this.totalItems.set(page.totalPages * this.pageSize);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }
}
