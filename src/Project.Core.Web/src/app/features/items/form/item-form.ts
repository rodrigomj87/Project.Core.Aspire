import { Component, inject, signal, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { HttpErrorResponse } from '@angular/common/http';
import { ItemService } from '../../../core/services/item.service';
import { CategoryService } from '../../../core/services/category.service';
import { Category } from '../../../core/models/category.model';
import { Item } from '../../../core/models/item.model';

@Component({
  selector: 'app-item-form',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatFormFieldModule, MatInputModule, MatSelectModule,
    MatDatepickerModule, MatNativeDateModule,
    MatButtonModule, MatCardModule, MatProgressBarModule, MatSnackBarModule,
  ],
  template: `
    <div class="form-header">
      <h2>{{ isEdit() ? titleEdit : titleNew }}</h2>
    </div>

    @if (loading()) {
      <mat-progress-bar mode="indeterminate" />
    }

    <mat-card class="form-card">
      <form [formGroup]="form" (ngSubmit)="submit()">
        <mat-form-field appearance="outline" class="full-width">
          <mat-label i18n="@@form.name">Nome</mat-label>
          <input matInput formControlName="name" />
          @if (form.get('name')?.hasError('required') && form.get('name')?.touched) {
            <mat-error i18n="@@form.name.required">Nome é obrigatório</mat-error>
          }
          @if (form.get('name')?.hasError('maxlength')) {
            <mat-error i18n="@@form.name.maxlength">Máximo 50 caracteres</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label i18n="@@form.category">Categoria</mat-label>
          <mat-select formControlName="categoryId">
            @for (cat of categories(); track cat.id) {
              <mat-option [value]="cat.id">{{ cat.name }}</mat-option>
            }
          </mat-select>
          @if (form.get('categoryId')?.hasError('required') && form.get('categoryId')?.touched) {
            <mat-error i18n="@@form.category.required">Categoria é obrigatória</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label i18n="@@form.price">Preço</mat-label>
          <input matInput type="number" formControlName="price" min="0.01" max="999.99" step="0.01" />
          @if (form.get('price')?.hasError('required') && form.get('price')?.touched) {
            <mat-error i18n="@@form.price.required">Preço é obrigatório</mat-error>
          }
          @if (form.get('price')?.hasError('min')) {
            <mat-error i18n="@@form.price.min">Preço deve ser maior que zero</mat-error>
          }
          @if (form.get('price')?.hasError('max')) {
            <mat-error i18n="@@form.price.max">Preço máximo é R$ 999,99</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label i18n="@@form.releaseDate">Data de lançamento</mat-label>
          <input matInput [matDatepicker]="picker" formControlName="releaseDate" />
          <mat-datepicker-toggle matIconSuffix [for]="picker" />
          <mat-datepicker #picker />
          @if (form.get('releaseDate')?.hasError('required') && form.get('releaseDate')?.touched) {
            <mat-error i18n="@@form.releaseDate.required">Data é obrigatória</mat-error>
          }
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label i18n="@@form.description">Descrição</mat-label>
          <textarea matInput formControlName="description" rows="3"></textarea>
          @if (form.get('description')?.hasError('maxlength')) {
            <mat-error i18n="@@form.description.maxlength">Máximo 500 caracteres</mat-error>
          }
        </mat-form-field>

        <div class="form-actions">
          <button mat-button type="button" (click)="cancel()" i18n="@@form.cancel">Cancelar</button>
          <button mat-raised-button color="primary" type="submit" [disabled]="form.invalid || saving()">
            <span i18n="@@form.save">Salvar</span>
          </button>
        </div>
      </form>
    </mat-card>
  `,
  styles: [`
    .form-header { margin-bottom: 16px; }
    .form-card { padding: 24px; }
    .full-width { width: 100%; margin-bottom: 8px; }
    .form-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
  `],
})
export class ItemForm implements OnInit {
  private readonly itemService = inject(ItemService);
  private readonly categoryService = inject(CategoryService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly fb = inject(FormBuilder);
  private readonly snackBar = inject(MatSnackBar);

  readonly titleNew = $localize`:@@form.title.new:Novo Item`;
  readonly titleEdit = $localize`:@@form.title.edit:Editar Item`;

  readonly categories = signal<Category[]>([]);
  readonly loading = signal(false);
  readonly saving = signal(false);
  readonly isEdit = signal(false);

  private itemId: string | null = null;

  readonly form = this.fb.group({
    name: ['', [Validators.required, Validators.maxLength(50)]],
    categoryId: ['', Validators.required],
    price: [null as number | null, [Validators.required, Validators.min(0.01), Validators.max(999.99)]],
    releaseDate: [null as Date | null, Validators.required],
    description: ['', Validators.maxLength(500)],
  });

  ngOnInit(): void {
    this.categoryService.getAll().subscribe((cats) => this.categories.set(cats));

    this.itemId = this.route.snapshot.paramMap.get('id');
    if (this.itemId) {
      this.isEdit.set(true);
      this.loading.set(true);
      this.itemService.getById(this.itemId).subscribe({
        next: (item: Item) => {
          this.form.patchValue({
            name: item.name,
            categoryId: item.categoryId,
            price: item.price,
            releaseDate: new Date(item.releaseDate),
            description: item.description,
          });
          this.loading.set(false);
        },
        error: () => this.loading.set(false),
      });
    }
  }

  submit(): void {
    if (this.form.invalid) return;

    const val = this.form.value;
    const date = val.releaseDate as Date;
    const dateStr = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
    const payload = {
      name: val.name!,
      categoryId: val.categoryId!,
      price: val.price!,
      releaseDate: dateStr,
      description: val.description ?? '',
    };

    this.saving.set(true);
    const op = this.isEdit()
      ? this.itemService.update(this.itemId!, payload)
      : this.itemService.create(payload);

    op.subscribe({
      next: () => {
        this.saving.set(false);
        this.router.navigate(['/app/items']);
      },
      error: (err: HttpErrorResponse) => {
        this.saving.set(false);
        const message = this.extractErrorMessage(err);
        this.snackBar.open(message, 'Fechar', { duration: 5000, panelClass: 'error-snack' });
      },
    });
  }

  cancel(): void {
    this.router.navigate(['/app/items']);
  }

  private extractErrorMessage(err: HttpErrorResponse): string {
    if (err.status === 401 || err.status === 403) {
      return $localize`:@@error.unauthorized:Sem permissão para executar esta ação.`;
    }
    if (err.status === 400 && err.error?.errors) {
      const errors: string[] = err.error.errors.map((e: { description: string }) => e.description);
      return errors.join(' ');
    }
    return $localize`:@@error.generic:Ocorreu um erro. Tente novamente.`;
  }
}

