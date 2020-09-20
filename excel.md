**Excel Tips and Tricks**

[[_TOC_]]

# Replace line break
- In Excel, choose Edit>Replace
- Click in the Find What box
- Hold the Alt key, and (on the number keypad), type 0010
> This represents a line break in Excel.\
> You won't see anything in the 'Find What' box.

----------------------------------------------

# Clean cells
```vb
Sub CleanCells()
  'Strips special characters (line feeds, etc.) from all selected cells
  Dim Cell    As Range
  For Each Cell In Selection
     Cell.Value = WorksheetFunction.Clean(Cell.Value)
  Next Cell
End Sub
```

----------------------------------------------

# Replace line break by space
```vb
Sub delchrs()
Selection.Replace chr(13), " "
End Sub
```

----------------------------------------------

