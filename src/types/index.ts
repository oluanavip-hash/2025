import { Session } from '@supabase/supabase-js';

export interface User {
  id: string;
  app_metadata: { [key: string]: any };
  user_metadata: { [key: string]: any };
  aud: string;
  created_at: string;
}

export interface Team {
  id: number;
  name: string;
  league_id: number;
  image1: string;
  image2: string;
  price: number;
  created_at: string;
  leagues: {
    name: string;
  }
  stock?: ProductStock[];
}

export interface ProductStock {
  id: number;
  team_id: number;
  size: string;
  stock_quantity: number;
  created_at: string;
  updated_at: string;
}

export interface CartItem {
  team: Team;
  size: string;
  quantity: number;
}

export interface League {
  id: number;
  name: string;
  created_at: string;
}

export interface Profile {
  id: string;
  full_name: string;
  phone: string;
  balance: number;
  role: string;
}

export interface Order {
  id: number;
  created_at: string;
  user_id: string | null;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  delivery_address: any; // JSONB
  items: {
    id: number;
    name: string;
    size: string;
    quantity: number;
    price: number;
  }[];
  subtotal: number;
  discount: number;
  total_amount: number;
  status: string;
  payment_method: string;
}

export interface Customer {
  id: string;
  avatar: string;
  name: string;
  email: string;
  phone: string;
  orders: number;
  totalSpent: number;
}

export interface AuthContextType {
  session: Session | null;
  user: User | null;
  profile: Profile | null;
  loading: boolean;
  signOut: () => Promise<void>;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, name: string, phone: string) => Promise<void>;
}
