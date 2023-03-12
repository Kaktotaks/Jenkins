//
//  ViewController.swift
//  RXSwiftIntro
//
//  Created by Леонід Шевченко on 04.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

struct User {
    let name: String
    let surname: String
    let imageName: String
}

struct ViewModel {
    var scopeOfUsers = PublishSubject<[User]>()

    func fetchUsers() {
        let users = [
            User(name: "Leonid", surname: "Shavchenko", imageName: "person"),
            User(name: "Svitalana", surname: "Shavchenko", imageName: "person"),
            User(name: "Bogdanchik", surname: "Shavchenko", imageName: "person")
        ]

        scopeOfUsers.onNext(users)
        scopeOfUsers.dispose()
    }
}

class ViewController: UIViewController {

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    let viewModel = ViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.frame = view.bounds
        bintTableView()

        let subject = BehaviorSubject<Int>(value: 0)

        subject.subscribe { event in
            print("Перший підписник \(event)")
        }
        
//        subject.onNext(1)
//        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        
        subject.subscribe { event in
            print("Другий підписник \(event)")
        }
        
        subject.onNext(5)
        subject.onNext(6)
        
        subject.subscribe { event in
            print("Третій підписник \(event)")
        }
        
        subject.onNext(7)
        subject.onNext(8)
        
        subject.disposed(by: bag)

    }

    func bintTableView() {
        viewModel.scopeOfUsers.bind(
            to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
                cell.textLabel?.text = model.name + " " + model.surname
                cell.imageView?.image = UIImage(systemName: model.imageName)
            }.disposed(by: bag)

        tableView.rx.modelSelected(User.self).bind { user in
            print(user.name)
        }.disposed(by: bag)

        viewModel.fetchUsers()
    }
}
