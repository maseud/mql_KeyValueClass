//+------------------------------------------------------------------+
//|                                                         Omidi_EA |
//|                                     Copyright 2023, Maseud Omidi |
//|                                                 maseud@gmail.com |
//+------------------------------------------------------------------+
#property copyright "2023, author - Maseud Omidi"
#property link      "maseud@gmail.com"
#property library
#property strict

#define NEGATIVE_INDEX -1 // Indexing starts from zero

#ifndef __MQL5__
   template <typename T>
   void ArrayRemove(T& A[], int pos, int count=WHOLE_ARRAY)
     {
      if(count == WHOLE_ARRAY)
         count = INT_MAX;
      int size = ArraySize(A);
      if(count > (size-pos))
         count = size-pos;
      for(int i=pos; i<(size-count); i++)
         A[i] = A[i+count];
      ArrayResize(A, size-count);
     }
#endif

//+------------------------------------------------------------------+
template <typename TKey, typename TValue>
class KeyValueClass
  {
protected:
   //+------------------------------------------------------------------+
   int               setCount(int NewLength) // Sets items array count
     {
      int reserve = (int)fmax(ArraySize(ItemKeys)/10, 1000);
      ArrayResize(ItemKeys, NewLength, reserve);
      ArrayResize(ItemValues, NewLength, reserve);
      return Count();
     }
public:
   //+------------------------------------------------------------------+
   TKey              ItemKeys[]; // Items array
   TValue            ItemValues[]; // Items array
   //+------------------------------------------------------------------+
   int               Count() // Returns items array count
     {
      return ArraySize(ItemKeys);
     }
   //+------------------------------------------------------------------+
   void              KeyValueClass()
     {
      setCount(0);
     }
   //+------------------------------------------------------------------+
   void             ~KeyValueClass() // Free items array
     {
      DeleteAll();
      ArrayFree(ItemKeys);
      ArrayFree(ItemValues);
     }
   //+------------------------------------------------------------------+
   int               Index(TKey key) // Returns index of the given key or NEGATIVE_INDEX if not found
     {
      for(int i=0; i<Count(); i++)
         if(ItemKeys[i] == key)
            return i;
      return NEGATIVE_INDEX;
     }
   //+------------------------------------------------------------------+
   TKey              Key(int index) // Returns Key of the given index or NULL in case of ilegall index
     {
      if(index>NEGATIVE_INDEX && index<Count())
         return ItemKeys[index];
      return NULL;
     }
   //+------------------------------------------------------------------+
   bool              Key(int index, TKey NewKey) // Returns Key of the given index or NULL in case of ilegall index
     {
      if(index>NEGATIVE_INDEX && index<Count())
        {
         ItemKeys[index] = NewKey;
         return true;
        }
      return false;
     }

   TValue              ValueByIndex(int index) // Returns of the given index Value or NULL in case of ilegall index
     {
      if(index>NEGATIVE_INDEX && index<Count())
         return ItemValues[index];
      return NULL;
     }
   //+------------------------------------------------------------------+
   int               DeleteByIndex(int index) // Deletes item and returns its index or returns NEGATIVE_INDEX if not found
     {
      int c = Count();
      if((index>NEGATIVE_INDEX) && (index<c) &&(c>0))
        {
         //if (CheckPointer(ItemValues[index]) == POINTER_DYNAMIC)
         //delete(ItemValues[index]);
         ArrayRemove(ItemKeys, index, 1);
         ArrayRemove(ItemValues, index, 1);
         setCount(c-1);
         return index;
        }
      return NEGATIVE_INDEX;
     }
   //+------------------------------------------------------------------+
   int               Delete(TKey key) // Deletes item and returns its index or returns NEGATIVE_INDEX if not found
     {
      return DeleteByIndex(Index(key));
     }
   //+------------------------------------------------------------------+
   int               DeleteAll() // Deletes item and returns its index or returns NEGATIVE_INDEX if not found
     {
      ArrayRemove(ItemKeys, 0);
      ArrayRemove(ItemValues, 0);
      return setCount(0);
     }
   //+------------------------------------------------------------------+
   TValue              Value(TKey key) // Returns value of the given key or NULL if not found
     {
      return ValueByIndex(Index(key));
     }
   //+------------------------------------------------------------------+
   int               Value(TKey key, TValue NewValue) // Sets the value of the given key or add a new one if not found
     {
      int i = Index(key);
      if(i<0)
        {
         i = Count();
         setCount(i+1);
         ItemKeys[i] = key;
        }
      ItemValues[i] = NewValue;
      return i;
     }
  };
//+------------------------------------------------------------------+
