PROMPT Create small tables...
DROP TABLE small_categories
/
CREATE TABLE small_categories (
        id            VARCHAR2(5) PRIMARY KEY,
        min_items     INTEGER,
        max_items     INTEGER
)
/
DROP TABLE small_items
/
CREATE TABLE small_items (
        id              VARCHAR2(3) PRIMARY KEY,
        item_name       VARCHAR2(30),
        category_id     VARCHAR2(5),
        price           NUMBER,
        value           NUMBER
)  
/
PROMPT Insert small data
DECLARE

  i     PLS_INTEGER := 0;
  PROCEDURE Ins_category(
                        p_id	        VARCHAR2,
                        p_min_items   PLS_INTEGER,
                        p_max_items   PLS_INTEGER) IS
  BEGIN

    INSERT INTO small_categories VALUES (p_id, p_min_items, p_max_items);

  END Ins_category;

  PROCEDURE Ins_item(p_item_name  VARCHAR2, 
                    p_category     VARCHAR2,
                    p_price        NUMBER,
                    p_value   NUMBER) IS
  BEGIN

    i := i + 1;
    INSERT INTO small_items VALUES (i, p_item_name, p_category, p_price, p_value);

  END Ins_item;

BEGIN

  DELETE small_categories;
  Ins_category ('CAT_A', 1, 2);
  Ins_category ('CAT_B', 1, 2);
  Ins_category ('AL', 3, 3);

  DELETE small_items;
  Ins_item('Item-A-1', 'CAT_A', 1, 1);  
  Ins_item('Item-A-2', 'CAT_A', 2, 2);  
  Ins_item('Item-A-3', 'CAT_A', 3, 3);

  Ins_item('Item-B-1', 'CAT_B', 1, 6);  
  Ins_item('Item-B-2', 'CAT_B', 2, 4);  
  Ins_item('Item-B-3', 'CAT_B', 3, 2);  
END;
/
BREAK ON category_id
SELECT category_id, id, item_name, price, value
  FROM small_items
 ORDER BY 1, 2
/