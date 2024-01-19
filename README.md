# Animals

![This is an image](https://ik.imagekit.io/m1ke1magek1t/Animals_oPEWOIJqX.png?updatedAt=1705683689856)

## Screens
- List of animals
- Detail of animals ```Double tap the image to like & dislike```
- List of liked image


### Clean Architecture
![Clean Architechture](https://ik.imagekit.io/m1ke1magek1t/CleanArch.png?updatedAt=1705685276939)

I use the clean architecture that might be worth looking into in larger projects.
```
├─ Networking
├─ Shared
├─ Modules
    ├─ Home
    ├─ Details
        ├─ Data
            ├─ Repositories
            ├─ Requests
            ├─ Responses
        ├─ Domain
            ├─ UseCases
            ├─ Entities
        ├─ Presentation
            ├─ DetailVC
            ├─ DetailVM
            ├─ Views
                ├─ DetailContentCell
├─ Appplication
```

### Design Pattern MVVM-FRP (✅ Unidirectional data flow)
#### ViewModel
```
internal final class StoreVM {
    struct Action {
        ... all the actions from the view
    }

    class State {
        ... all the state/datasources
    }

    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        ... where all the actions observed and giving the side effect to the state
    }
}
```

#### ViewController
```
private func bindViewModel() {
   let input = StoreVM.Input(...)
   let output = viewModel.transform(input, cancellables: &cancellables)
	
   output.$...
      .sink { [weak self] _ in
      .... // do something to the view when there is changes on the state
      }
      .store(in: &cancellables)
}
```


### Programatically UI
I'm more confident to use programatically to avoid error or conflict on the XIB or Storyboard
```
private let imageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.layer.masksToBounds = true
		return image
	}()
        
view.addSubview(imageView)
```


### Auto Layout
To configure auto layout I use [SnapKit](https://github.com/SnapKit/SnapKit) to reduce the code and make development faster.

without SnapKit
```
  imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
  imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
  imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
```

with Snapkit
```
imageView.snp.makeConstraints { make in
    make.width.equalTo(200)
    make.height.equalTo(280)
    make.top.equalTo(contentView).offset(20)
    make.centerX.equalTo(contentView)
}
```


### Networking
Using [Alamofire](https://github.com/Alamofire/Alamofire) to manage the network request and I build an abstraction for the APIRequest
```
internal struct AnimalRequest: APIRequest {
	typealias Response = [HomeContent]
	let numOfAnimal: Int
	
	var baseURL: String { NetworkConfiguration.BaseURL.animal.rawValue }
	var method: HTTPMethod = .get
	var path: String
	var headers: [String : Any] = ["X-Api-Key": "pfFQJxLiPMYqvY5rZXbYdw==VBjYVanTRFZdEhx9"]
	var body: [String : Any] = [:]

  init(animalName: String, numOfAnimal: Int) {
		self.numOfAnimal = numOfAnimal
		self.path = "v1/animals?name=\(animalName)"
	}
	
	func map(_ data: Data) throws -> [HomeContent] {
		let decoded = try JSONDecoder().decode([AnimalResponse].self, from: data)
		return decoded.prefix(upTo: numOfAnimal).map { HomeContent(name: $0.name ?? "", color: UIColor.getRandomPrefixColor()) }
	}
}

```


### Unit Testing
- **XCTest**


### Dependency
- Local storage **CoreData**
- Networking  using **Alamofire**
- Auto Layout using **Snapkit**
- Handling image using **Kingfisher**
- **CombineCocoa**


## Getting Started
### 1. Clone this project
You can clone the project by Http or Ssh on your terminal
- HTTPS ``` https://github.com/mikekaels/Animals.git ```
- SSH ``` git clone git@github.com:mikekaels/Animals.git ```
- Or download the project

### 2. Instalation
Make sure you have installed [cocoapods](https://cocoapods.org/) on your machine, if not please do this command in your Terminal: 
```bash
$ sudo gem install cocoapods
```
If you already install cocoapods, in your terminal go to inside the project directory and do this command: 
```bash
pod install
```
### 3. Open the .xcworkspace file

### 4. Run
Select the simulator or device
and Run the project!

### 5. Done
