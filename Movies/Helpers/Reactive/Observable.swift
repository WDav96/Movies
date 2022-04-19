//
//  Observable.swift
//  Movies
//
//  Created by J.R. on 18/04/22.
//

import Foundation

class Observable<T> {
    
    typealias Listener = (T) -> Void
    
    // MARK: - Internal Propertiers
    
    var observe: Listener = { _ in }
        
    private(set) var property: T? {
        didSet {
            if let property = property {
                thread.async {
                    self.observe(property)
                }
            }
        }
    }
    
    // MARK: - Private Propertiers
    
    private let thread : DispatchQueue
    
    // MARK: - Initializers
    
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = .main) {
        self.thread = dispatcherThread
        self.property = value
    }
    
    // MARK: - Internal Methods
    
    func observe(_ listener: @escaping Listener) {
        observe = listener
    }
    
    // MARK: - Fileprivaye Methods
    
    fileprivate func postValue(_ value: T?) {
        property = value
    }
    
}

class MutableObservable<T>: Observable<T> {
    
    // MARK: - Internal Override Methods
    
    override func postValue(_ value: T?) {
        super.postValue(value)
    }
    
}
