//
//  Single+Extensions.swift
//  ArcsinusSampleApp
//
//  Created by Danil Blinov on 20.03.2021.
//

import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait, Element == Result<Data, APIError> {
	
	func map<T: Decodable>(to type: T.Type, decodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,  haveHierarchy: Bool = false) -> Single<Result<T, APIError>> {
		return flatMap { element -> Single<Result<T, APIError>> in
			switch element {
			case .success(let json):
				do {
					guard let obj = try json.decode(as: T.self, decodingStrategy) else { return .just(.failure(.invalidData)) }
					return .just(.success(obj))
				} catch let error {
					print(error)
					return .just(.failure(.jsonConversationFailed))
				}
				
			case .failure(let error):
				return .just(.failure(error))
			}
		}
	}
	
}

private extension Data {
	
	func decode<T: Decodable>(as type: T.Type, _ decodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> T? {
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = decodingStrategy
			return try decoder.decode(type, from: self)
		} catch {
			throw error
		}
	}
	
}
