import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Item, ItemsPage, CreateItemRequest, UpdateItemRequest } from '../models/item.model';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ItemService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/items`;

  getPage(pageNumber: number, pageSize: number, name?: string): Observable<ItemsPage> {
    let params = new HttpParams()
      .set('pageNumber', pageNumber)
      .set('pageSize', pageSize);
    if (name) {
      params = params.set('name', name);
    }
    return this.http.get<ItemsPage>(this.baseUrl, { params });
  }

  getById(id: string): Observable<Item> {
    return this.http.get<Item>(`${this.baseUrl}/${id}`);
  }

  create(request: CreateItemRequest): Observable<Item> {
    return this.http.post<Item>(this.baseUrl, request);
  }

  update(id: string, request: UpdateItemRequest): Observable<Item> {
    return this.http.put<Item>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
