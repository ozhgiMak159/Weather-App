//
//  Description .swift
//  Weather App
//
//  Created by Maksim  on 27.01.2024.
//


/*
 Вопросы:
    1. Alamofire vs URLSession(+/-)
    2. Struct/Class, что лучше?
    3. Принцип Dry
    4. MVC
    5. Decodable и другие товарищи
  
-------------------------------------------
 
 Ответы:
    1. Alamofire - это библиотека, позволяет сделать понятный и читабельный сетевой запрос.
 
 class NetworkManager {
     static let shared = NetworkManager()

     private init() { }

     func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void) {
         AF.request(url).validate().responseDecodable(of: T.self) { response in
                 switch response.result {
                 case .success(let data):
                     completion(.success(data))
                 case .failure(let error):
                     completion(.failure(error))
                 }
             }
     }
 }
 
 
    URLSession — это фундаментальная встроенная библиотека Swift,
        которая позволяет делать сетевые запросы. Так как это база, требуется писать больше кода, для сетевого запроса.
    
 class NetworkManager {
     static let shared = NetworkManager()
     
     private init() { }
     
     func request<T: Decodable>(_ url: String, completion: @escaping (Result<T, Error>) -> Void) {
         guard let url = URL(string: url) else { return }
         
         URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             guard let data = data else {
                 completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                 return
             }
             
             do {
                 let decodedData = try JSONDecoder().decode(T.self, from: data)
                 completion(.success(decodedData))
             } catch {
                 completion(.failure(error))
             }
 
         }.resume()
     }
 }
 
 СРАВНЕНИЕ:
 - Легкость и читабельность.
    Alamofire, более читабельная, управляемая, все действия находятся под капотом.
    Urlsession, требуется больше ручной работы
 
 - Зависимость
    Alamofire,проект будет зависеть от версии библиотеки.
    Urlsession, тут нет зависимости, так как это встроенная библиотека.
 
 - Документация
    Alamofire, очень хорошая документация + сообщество в группах
    Urlsession, только официальная документация и статьи на стекОферФлоу.
 
 Вывод: Все зависит от проекта, алома, лучше по читабельности и простоте, чем юрл.
 */


/*
Класс/Структура что лучше?

 Структура подходит:
    - Если есть небольшие и простые значение свойства
    - Значение следует копировать, а не передавать по ссылке
    - Свойства тоже валюТипы
    - Нет необходимости наследованные
 */


/*
 Принцип ДРЮ:
 "Перестань повторять себя", принцип гласить, писать многофункциональный не повторяющий код.
 
 ПРОБЛЕМА: Каждая функция имеет свою формулу расчета площади, что приводит к дублированию кода.
 
 func calculateRectangleArea(width: Double, height: Double) -> Double {
     let area = width * height
     return area
 }

 func calculateTriangleArea(base: Double, height: Double) -> Double {
     let area = (base * height) / 2
     return area
 }

 func calculateCircleArea(radius: Double) -> Double {
     let area = Double.pi * radius * radius
     return area
 }
 
 РЕШЕНИЕ:
 
 func calculateArea(shape: String, dimensions: [Double]) -> Double {
     var area: Double = 0.0
     
     switch shape {
     case "rectangle":
         area = dimensions[0] * dimensions[1]
     case "triangle":
         area = (dimensions[0] * dimensions[1]) / 2
     case "circle":
         area = Double.pi * dimensions[0] * dimensions[0]
     default:
         print("Invalid shape")
     }
     
     return area
 }
 
 Используя одну функцию, которая может обрабатывать несколько форм и размеров,
 мы устраняем дублирование кода и делаем его более удобным в сопровождении и гибким.
 
 */

/*
 Протокол Декодебл - декодирует данные из внешного представление. Преобразование Джесон файла в структуру/класс, в читабельный вид.
 Протокол Энкодабл - кодирует данные во внешнее представление. Формирует Джесон файл.
 Протокол Котобл - содержит Декодобл/Энкотобл.
 */
