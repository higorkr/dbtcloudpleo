{% macro eur_conversion(currency, amount) %}

    CASE 
    WHEN {{currency}} = 'dkk' THEN 7.45 * {{amount}}
    WHEN {{currency}} = 'sek' THEN 11.22 * {{amount}}
    WHEN {{currency}} = 'gbp' THEN 0.87 * {{amount}}
    WHEN {{currency}}= 'eur' THEN 1 * {{amount}}
    ELSE NULL END

{% endmacro %}