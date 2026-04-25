export interface Item {
  id: string;
  name: string;
  categoryId: string;
  category?: string;
  price: number;
  releaseDate: string;
  description: string;
  lastUpdatedBy: string;
}

export interface ItemSummary {
  id: string;
  name: string;
  category: string;
  price: number;
  releaseDate: string;
  lastUpdatedBy: string;
}

export interface ItemsPage {
  totalPages: number;
  data: ItemSummary[];
}

export interface CreateItemRequest {
  name: string;
  categoryId: string;
  price: number;
  releaseDate: string;
  description: string;
}

export interface UpdateItemRequest {
  name: string;
  categoryId: string;
  price: number;
  releaseDate: string;
  description: string;
}
