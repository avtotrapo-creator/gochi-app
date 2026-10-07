-- გოჭი ჯის აპის Supabase ბაზის სქემა
-- გაუშვი Supabase-ს დეშბორდზე: შენი პროექტი → SQL Editor → New query → ჩასვი ეს მთლიანად → Run

create table public.orders (
  id bigint primary key,
  raw text,
  phone text default '',
  date text,
  courier text default '',
  done boolean default false,
  by_user text default '',
  rating int,
  updated_at timestamptz default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_orders_updated_at
before update on public.orders
for each row execute function public.set_updated_at();

-- თავისუფალი წვდომა anon გასაღებით (ისევე, როგორც პიწკინას ბაზაშია) —
-- რადგან ეს კერძო აპია ინტერნეტში უჩვენოდ გამოსაქვეყნებელი ბმულის გარეშე,
-- RLS გამორთულია რომ აპმა პირდაპირ იმუშაოს.
alter table public.orders disable row level security;
