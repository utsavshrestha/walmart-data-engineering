{% set configs =    
    [
        {
            "table": source('walmart', 'raw_orders'),
            "columns": """
                o.order_id,
                o.order_timestamp,
                o.order_status,
                o.total_amount,
                o.payment_method,
                o.created_timestamp as order_created_timestamp,
                o.updated_timestamp as order_updated_timestamp
            """,
            "alias": "o",
        },
        {
            "table": source('walmart', 'raw_customers'),
            "columns": """
                c.customer_id,
                c.first_name,
                c.last_name,
                c.email,
                c.phone,
                c.city,
                c.province,
                c.country,
                c.created_timestamp as customer_created_timestamp,
                c.updated_timestamp as customer_updated_timestamp
            """,
            "alias": "c",
            "join_condition": "o.customer_id = c.customer_id",
        },
    
        {
            "table": source('walmart', 'raw_order_items'),
            "columns": """
                oi.order_item_id,
                oi.quantity,
                oi.unit_price,
                oi.line_amount,
                oi.created_timestamp as order_item_created_timestamp,
                oi.updated_timestamp as order_item_updated_timestamp
            """,
            "alias": "oi",
            "join_condition": "o.order_id = oi.order_id",
        },
        {
            "table": source('walmart', 'raw_products'),
            "columns": """
                p.product_id,
                p.product_name,
                p.category,
                p.brand,
                p.price,
                p.created_timestamp as product_created_timestamp,
                p.updated_timestamp as product_updated_timestamp
            """,
            "alias": "p",
            "join_condition": "oi.product_id = p.product_id",
        },
        {
            "table": source('walmart', 'raw_stores'),
            "columns": """
                s.store_id,
                s.store_name,
                s.city as store_city,
                s.province as store_province,
                s.country as store_location,
                s.created_timestamp as store_created_timestamp,
                s.updated_timestamp as store_updated_timestamp
            """,
            "alias": "s",
            "join_condition": "o.store_id = s.store_id",    
        },
        {
            "table": source("walmart", "raw_employees"),
            "columns": """
                e.employee_id,
                e.first_name as employee_first_name,
                e.last_name as employee_last_name,
                e.email as employee_email,
                e.job_title as employee_job_title,
                e.salary as employee_salary,
                e.created_timestamp as employee_created_timestamp,
                e.updated_timestamp as employee_updated_timestamp
            """,
            "alias": "e",
            "join_condition": "s.store_id = e.store_id",

        }
    ]
%}

SELECT 
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM 
    {% for config in configs %}
        {% if loop.first %}
            {{ config['table'] }} AS {{ config['alias'] }}
        {% else %}
LEFT JOIN
        {{ config['table'] }} AS {{ config['alias'] }} 
        ON {{ config['join_condition'] }}
        {% endif %}
    {% endfor %}