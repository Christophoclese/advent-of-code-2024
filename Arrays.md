# Arrays

https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.4
https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0

```pwsh
using namespace System.Collections.Generic
$myList = [List[int]]@(1,2,3)
$myList.Add(4)
$mylist.Insert(0,10)
$mylist[0]
$mylist[0] = 0
$mylist.Add(10)
$mylist.Add(10)
$mylist.Add(10)
$mylist.Remove(10)
$mylist.RemoveAll(10)
$mylist.RemoveAt(0)
```
