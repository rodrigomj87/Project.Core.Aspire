import { Component, inject } from '@angular/core';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';

export interface DeleteConfirmData {
  name: string;
}

@Component({
  selector: 'app-delete-confirm-dialog',
  standalone: true,
  imports: [MatDialogModule, MatButtonModule],
  template: `
    <h2 mat-dialog-title i18n="@@delete.title">Confirmar exclusão</h2>
    <mat-dialog-content>
      <p i18n="@@delete.message">Deseja excluir <strong>{{ data.name }}</strong>? Esta ação não pode ser desfeita.</p>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button mat-dialog-close i18n="@@delete.cancel">Cancelar</button>
      <button mat-raised-button color="warn" [mat-dialog-close]="true" i18n="@@delete.confirm">
        Excluir
      </button>
    </mat-dialog-actions>
  `,
})
export class DeleteConfirmDialog {
  readonly dialogRef = inject(MatDialogRef<DeleteConfirmDialog>);
  readonly data = inject<DeleteConfirmData>(MAT_DIALOG_DATA);
}
