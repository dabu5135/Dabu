

import Alamofire
import ObjectMapper

struct PostService: APIServiceType {

  static func post(id: Int, completion: @escaping (DataResponse<Post>) -> Void) {
    
    let urlString = self.url("/posts/\(id)")
    
    Alamofire
      .request(urlString)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        let newResponse = response.flatMapResult { json -> Result<Post> in
          if let post = Mapper<Post>().map(JSONObject: json) {
            return .success(post)
          } else {
            return .failure(MappingError(from: json, to: Post.self))
          }
        }
        completion(newResponse)
      }
  }
  
  static func like(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil) {
    NotificationCenter.default.post(
      name: .postDidLike,
      object: self,
      userInfo: ["postID": postID]
    )
    
    let urlString = self.url("/posts/\(postID)/likes")
    
    Alamofire
      .request(urlString, method: .post)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        if case .failure = response.result, response.response?.statusCode != 409 {
          NotificationCenter.default.post(
            name: .postDidUnLike,
            object: self,
            userInfo: ["postID": postID]
          )
        }
        let newResponse = response.mapResult { _ in }
        completion?(newResponse)
      }
  }
  
  static func unlike(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil) {
    NotificationCenter.default.post(
      name: .postDidUnLike,
      object: self,
      userInfo: ["postID": postID]
    )
    
    let urlString = self.url("/posts/\(postID)/likes")
    
    Alamofire
      .request(urlString, method: .delete)
      .validate(statusCode: 200..<400)
      .responseJSON { response in
        if case .failure = response.result {
          NotificationCenter.default.post(
            name: .postDidLike,
            object: self,
            userInfo: ["postID": postID]
          )
        }
        let newResponse = response.mapResult { _ in }
          completion?(newResponse)
    }
  }
  
  static func create(
    image: UIImage,
    message: String?,
    progress: @escaping (Progress) -> Void,
    completion: @escaping (DataResponse<Post>
  ) -> Void) {
    
    let urlString = self.url("/posts")
    Alamofire.upload(
      multipartFormData: { formData in
        if let imageData = UIImageJPEGRepresentation(image, 1) {  // JPEG인코딩, 손실압축
          //        UIImagePNGRepresentation(<#T##image: UIImage##UIImage#>) PNG 인코딩, 무손실압축
          formData.append(
            imageData,
            withName: "photo",
            fileName: "photo",
            mimeType: "image/jpeg"     // imageData가 어떤형식으로 된 이미지인지 나타내주는 타입
          )
        }
        if let textData = message?.data(using: .utf8) {
          formData.append(
            textData,
            withName: "message"
          )
        }
      },
      to: urlString,
      method: .post,
      encodingCompletion: { encodingResult in
        switch encodingResult {
        case .success(let request, _, _):
          print("인코딩 성공 \(request)")
          request
            .uploadProgress(closure: progress)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
              let newResponse = response.flatMapResult { json -> Result<Post> in
                if let post = Mapper<Post>().map(JSONObject: json) {
                  return .success(post)
                } else {
                  return .failure(MappingError(from: json, to: Post.self))
                }
              }
              completion(newResponse)
              if let post = newResponse.result.value {
                NotificationCenter.default.post(
                  name: .postDidCreate,
                  object: self,
                  userInfo: ["post": post]
                )
              }
          }
        case .failure(let error):
          print("인코딩 실패 \(error)")
          let response = DataResponse<Post>(
            request: nil,
            response: nil,
            data: nil,
            result: .failure(error)
          )
          completion(response)
        }
      }
    )
  }
  
}
