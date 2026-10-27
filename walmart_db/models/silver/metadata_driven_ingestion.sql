{% set configs =    
    [
        {
            "table": "{{ source("walmart", "raw_orders") }}",
            "columns": """
                order_id,
                customer_id,
                order_date,
                order_status,
                order_total_amount,
                order_total_quantity,
                created_timestamp as order_created_timestamp,
                updated_timestamp as order_updated_timestamp,
                is_active
            """,
            "alias": "o",
        },
        {
            "table": "{{ source("walmart", "raw_customers") }}",
            "columns": """
                customer_id,
                first_name,
                last_name,
                email,
                phone_number,
                address,
                city,
                state,
                zip_code,
                country,
                created_timestamp as customer_created_timestamp,
                updated_timestamp as customer_updated_timestamp,
                is_active
            """,
            "alias": "c",
            "join_condition": "o.customer_id = c.customer_id",
        },
        {
            "table": "{{ source("walmart", "raw_products") }}",
            "columns": """
                product_id,
                product_name,
                category,
                price_in_cents,
                created_timestamp as product_created_timestamp,
                updated_timestamp as product_updated_timestamp,
                is_active
            """,
            "alias": "p",
            "join_condition": "o.product_id = p.product_id",
        },
        {
            "table": "{{ source("walmart", "raw_order_items") }}",
            "columns": """
                order_item_id,
                order_id,
                product_id,
                quantity,
                price_in_cents,
                created_timestamp as order_item_created_timestamp,
                updated_timestamp as order_item_updated_timestamp,
                is_active
            """,
            "alias": "oi",
            "join_condition": "o.order_id = oi.order_id AND p.product_id = oi.product_id",
        },
        {
            "table": "{{ source("walmart", "raw_payments") }}",
            "columns": """
                payment_id,
                order_id,
                payment_method,
                payment_amount_in_cents,
                created_timestamp as payment_created_timestamp,
                updated_timestamp as payment_updated_timestamp,
                is_active
            """,
            "alias": "pay",
            "join_condition": "o.order_id = pay.order_id",
        },
        {
            "table": "{{ source("walmart", "raw_stores") }}",
            "columns": """
                store_id,
                store_name,
                store_location,
                created_timestamp as store_created_timestamp,
                updated_timestamp as store_updated_timestamp,
                is_active
            """,
            "alias": "s",
            "join_condition": "o.store_id = s.store_id",    
        }
    ]
%}

select 
    {% for config in configs -%}
        {{ config["alias"] }}.{{ config["columns"] | trim}}
        {%- if not loop.last -%} , {% endif -%}
    {% endfor -%}
from 
    {% for config in configs -%}
        {% if loop.first -%}
            {{ config["table"] }} as {{ config["alias"] }}
        {%- else -%}
            left join {{config["table"] }} as {{ config["alias"] }} on {{config["join_condition"] }}
        {%- endif -%}
    {% endfor -%}
where
    {% for config in configs -%}
        {{ config["alias"]}}.is_active = 'Y'
        {%- if not loop.last -%} and {% endif -%}
    {% endfor -%}
