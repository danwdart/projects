data LL = LL deriving (Show)

-- Implement a normal Haskell version - as if it doesn't already have one!

data LinkedList = LinkedList {
    value :: String,
    next  :: Maybe LinkedList
}

printList ∷ LinkedList → IO ()
printList LinkedList { next = Nothing } = undefined
{-
printf("%d: %s\n", from, list->value);

    if (NULL != list->next) {
        printlist(list->next, from + 1);
    }
-}

fromHList ∷ [String] → LinkedList
fromHList = undefined
{-
LL* list = newlist();
    LL* orig_list = list;
    for (int i = 0; i < size; i++) {
        list->value = array[i];
        list->next = newlist();
        list = list->next;
    }
    return orig_list;
-}

-- from array?
insertList ∷ String → LinkedList → LinkedList
insertList = undefined
{-
char **tracer;
-}
