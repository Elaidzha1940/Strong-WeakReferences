How to manage strong & weak references with Async Await.
========================================================

  This implies a strong reference:
  --------------------------------
    
  ```````ruby
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
```````
    
 This is a strong reference:
 ---------------------------

  ```````ruby
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
```````
    
This is a strong reference:
---------------------------

  ```````ruby
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
```````
