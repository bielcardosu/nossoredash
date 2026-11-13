CREATE TABLE vendas AS
SELECT
  g AS id,
  DATE '2026-01-01' + (random()*300)::int AS data_venda,
  (ARRAY['Notebook','Mouse','Teclado','Monitor','Headset','Webcam'])[1+floor(random()*6)::int] AS produto,
  (ARRAY['Norte','Nordeste','Centro-Oeste','Sudeste','Sul'])[1+floor(random()*5)::int] AS regiao,
  1+floor(random()*5)::int AS quantidade,
  round((50+random()*2950)::numeric, 2) AS valor
FROM generate_series(1, 5000) g;