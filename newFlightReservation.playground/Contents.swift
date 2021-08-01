import Cocoa


struct User{
    let name:String
    let id:Int
    var userType:UserType
    
   
}

enum UserType{
    case firstClass
    case economic
}

struct Seat{
    var seatNumber:Int
    var seatType:SeatType
    var isAvailabile:Bool
    
}

enum SeatType{
    case firstClass
    case economic
}

class Plane{
    var seat:[Seat] = .init(repeating: Seat(seatNumber: 0, seatType: .firstClass,isAvailabile: true), count: 100)
    
    init() {
        for index in seat.indices{
            self.seat[index].seatNumber = index
            if index <= 40{
                self.seat[index].seatType = SeatType.firstClass
            } else {
                self.seat[index].seatType = SeatType.firstClass
            }
        }
    }
}

struct Booking{
    let userId:Int
    var seatNumber:Int
    
    mutating func changeSeat(canChange:Bool,newSeatNumber:Int){
        if canChange{
            seatNumber = newSeatNumber
        }else {
            print("Can't change seat number")
        }
    }
    
}

class Server{
    var bookList = [Int:Booking]()
    var plane:Plane
    var lock:NSLock
    var user:[Int:User]
    //var timer:Timer
    
    init() {
        plane = Plane()
        lock = NSLock()
        user = .init()
        handleBooking()
    }
    
    func addBooking(booking:Booking){
        DispatchQueue.global().async {
            self.lock.lock()
            self.bookList[booking.seatNumber] = booking
            self.lock.unlock()
            
        }
    }
    
    func handleBooking(){
        DispatchQueue.global().async {
            var booking = self.bookList.removeValue(forKey: 0)
            while !self.bookList.isEmpty{
                if self.user[booking!.userId]?.userType == .firstClass{
                    if self.plane.seat[booking!.seatNumber].isAvailabile {
                        self.lock.lock()
                        self.plane.seat[booking!.seatNumber].isAvailabile = false
                        print("Your Booking for this Seat Number \(booking!.seatNumber) done :)")
                        self.lock.unlock()
                            if self.timer(){
                                booking?.changeSeat(canChange:true,newSeatNumber: booking?.seatNumber)
                            }else{
                                booking?.changeSeat(canChange:false,newSeatNumber: booking?.seatNumber)
                        }
                    }
                } else {
                    if self.plane.seat[booking!.seatNumber].seatType == self.user[booking!.userId]?.userType{
                        if self.plane.seat[booking!.seatNumber].isAvailabile {
                            self.lock.lock()
                            self.plane.seat[booking!.seatNumber].isAvailabile = false
                            print("Your Booking for this Seat Number \(booking!.seatNumber) done :)")
                            self.timer()
                            self.lock.unlock()
                        }
                    } else {
                        print("Your Type not matche with seat number :(")
                    }
                }
            }
        }
    }
    
    func timer()-> Bool{
        let timer = Timer.scheduledTimer(timeInterval: 24*60*60,target: self,selector: "Timer Fried",userInfo: nil ,repeats: false)
        if timer.isValid{
            return true
        }
        return false
    }
    
   
   
       
}
let user = User(name: "marah", id: 1, userType: .firstClass)
let book = Booking(userId: user.id, seatNumber: 1)
let server = Server()
server.addBooking(booking: book)


