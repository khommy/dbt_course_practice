import pandas as pd

rows = pd.DataFrame({
    'dq_tab': ['cd', 'cd'],
    'dq_atr': ['ogrn', 'tax_num'],
    'dq_cd': [
        [{'dq1': 'min_value', 'dq_sql_code': 'MIN(age)'}],
        [{'dq2': 'max_value', 'dq_sql_code': 'MAX(total)'}]
    ]
})

params = {}
for _, row in rows.iterrows():
    dq_tab = row['dq_tab']
    dq_atr = row['dq_atr']
    
    if dq_tab not in params:
        params[dq_tab] = {}
        
    if dq_atr not in params[dq_tab]:
        params[dq_tab][dq_atr] = []
        
    for metric_dict in row['dq_cd']:
        dq_key = next(iter(metric_dict))
        dq_query = 'dq_sql_query' 
        
        params[dq_tab][dq_atr].append({
            'metrics': metric_dict[dq_key],
            'sql_query': metric_dict[dq_query]
        })

print(params)