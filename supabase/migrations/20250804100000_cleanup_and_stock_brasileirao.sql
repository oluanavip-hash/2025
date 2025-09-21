/*
# [STRUCTURAL & DATA] Limpeza de Produtos e Atualização de Estoque - Brasileirão A
Este script realiza a limpeza de produtos antigos da categoria "Brasileirão A" e garante que todos os novos produtos (com o sufixo "25/26 Tailandesa") tenham um estoque inicial de 100 unidades para cada tamanho (P, M, G, GG, XG).

## Query Description:
- **Exclusão de Dados:** O script removerá permanentemente todos os produtos da liga "Brasileirão A" que NÃO possuem "25/26 Tailandesa" em seu nome. Esta ação não pode ser desfeita.
- **Inserção/Atualização de Estoque:** Para cada produto novo, o script irá inserir ou atualizar o estoque para 100 unidades em todos os tamanhos padrão. Se um registro de estoque já existir, ele será atualizado; caso contrário, será criado. Isso garante que os dados de estoque fiquem consistentes.

## Metadata:
- Schema-Category: "Structural"
- Impact-Level: "High"
- Requires-Backup: true
- Reversible: false

## Structure Details:
- **Tabela Afetada (DELETE):** `teams`
- **Tabela Afetada (INSERT/UPDATE):** `product_stock`
- **Condição de Exclusão:** `league_id` correspondente a 'Brasileirão A' e `name` que não contém '%25/26 Tailandesa%'.
- **Dados de Estoque:** `stock_quantity` será definido como 100 para os tamanhos 'P', 'M', 'G', 'GG', 'XG'.

## Security Implications:
- RLS Status: As políticas de RLS existentes nas tabelas `teams` e `product_stock` serão respeitadas.
- Policy Changes: No
- Auth Requirements: Requer permissões de `DELETE` na tabela `teams` e `INSERT`/`UPDATE` na tabela `product_stock`.

## Performance Impact:
- Indexes: A operação de `DELETE` pode ser intensiva dependendo do número de registros a serem removidos. A operação de `INSERT`/`UPDATE` no estoque é otimizada pelo uso de `ON CONFLICT`.
- Triggers: Triggers existentes nas tabelas afetadas serão acionados.
- Estimated Impact: Médio. A execução pode levar alguns segundos dependendo do volume de dados.
*/
DO $$
DECLARE
    brasileirao_league_id INT;
    team_record RECORD;
    size_record TEXT;
BEGIN
    -- 1. Obter o ID da liga "Brasileirão A"
    SELECT id INTO brasileirao_league_id FROM leagues WHERE name = 'Brasileirão A' LIMIT 1;

    -- Verifica se a liga foi encontrada antes de prosseguir
    IF brasileirao_league_id IS NOT NULL THEN
        -- 2. Excluir produtos antigos da categoria "Brasileirão A"
        -- Apenas produtos que NÃO correspondem ao novo padrão de nome '25/26 Tailandesa' serão removidos.
        RAISE NOTICE 'Excluindo produtos antigos da liga Brasileirão A (ID: %)...', brasileirao_league_id;
        DELETE FROM teams
        WHERE league_id = brasileirao_league_id
        AND name NOT LIKE '%25/26 Tailandesa%';
        RAISE NOTICE 'Produtos antigos excluídos.';

        -- 3. Garantir estoque para todos os novos produtos da categoria "Brasileirão A"
        RAISE NOTICE 'Atualizando/inserindo estoque para novos produtos...';
        FOR team_record IN
            SELECT id FROM teams WHERE league_id = brasileirao_league_id AND name LIKE '%25/26 Tailandesa'
        LOOP
            -- Para cada time, percorre os tamanhos e garante o estoque
            FOREACH size_record IN ARRAY ARRAY['P', 'M', 'G', 'GG', 'XG']
            LOOP
                -- Insere um estoque de 100 unidades ou atualiza se já existir
                INSERT INTO product_stock (team_id, size, stock_quantity, updated_at)
                VALUES (team_record.id, size_record, 100, NOW())
                ON CONFLICT (team_id, size)
                DO UPDATE SET
                    stock_quantity = 100,
                    updated_at = NOW();
            END LOOP;
        END LOOP;
        RAISE NOTICE 'Estoque atualizado com sucesso para todos os novos produtos.';
    ELSE
        RAISE WARNING 'A liga "Brasileirão A" não foi encontrada. Nenhuma ação foi executada.';
    END IF;
END $$;
