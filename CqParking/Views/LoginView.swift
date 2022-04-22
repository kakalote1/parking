//
//  LoginView.swift
//  CqParking
//
//  Created by 王思远 on 2021/5/12.
//

import SwiftUI
import SwiftyJSON


var localConfig = UserDefaults.standard

struct LoginView: View {
    
    @State var isWXAppInstall: Bool = false
    @State var username: String = ""
    @State var password: String = ""
    @State var isEdit:Bool = false;
    @State var isLoading: Bool = false
    @State var isModal: Bool = false
    @State var message: String = "正在登录"
    @State var sendCode: String = "获取验证码"
    @State var sendBtnState: Bool = false;
    @State var loginBtnState: Bool = false;
    @State var pushMainView: Bool = false
    
    @State private var alertShow = false
    @State var alertTitle:String = ""
    @State var alertMessage:String = ""
    func startAlert(title:String,message:String){
        self.alertTitle = title
        self.alertMessage = message
        self.alertShow = true
    }
    func changeBtnState() {
        if self.username.isEmpty  && self.password.isEmpty {
            self.sendBtnState = true;
        } else {
            self.sendBtnState = false;
        }
    }
    func boolWXAppInstall(){
        if WXApi.isWXAppInstalled() {
            self.isWXAppInstall = true
        }
    }
    let nameText = Text("请填写手机号码").foregroundColor(.secondary).font(.system(size: 16))
    let pwdText = Text("请输入短信验证码").foregroundColor(.secondary).font(.system(size: 16))
    var body: some View {
        LoadingView(isLoading:self.$isLoading,message: self.$message,isModal:self.$isModal) {
            ScrollView {
                Text("愉悦停").font(.system(size: 36)).padding(.top,80)
                Text("在手机上找车位")
                    .foregroundColor(.gray)
                    .padding(.top,10)
                    .font(.system(size: 16))
            VStack {
                VStack(spacing:15) {
                    HStack {
                        Image(systemName: "iphone")
                        TextField("请输入手机号码",text: $username)
                            .keyboardType(UIKeyboardType.emailAddress)
                            .foregroundColor(.white)
                            .font(.system(size:18))
                    }
                    .padding(.horizontal,20)
                    .padding(.top,20)
                    Divider()
                    HStack {
                        Image(systemName: "lock")
                        SecureField("请输入短信验证码", text: $password) {
                            print("Password: \(self.password)")
                        }
                        .font(.system(size:18))
                        Button(action: {
                            HttpRequest(url: "http://123.207.189.27:7201/login/ConsumerLoginController/sendPinNumber").doPost(postData: ["\"phoneNum\"" : self.username]) { (value) in
                                let json = JSON(value)
                                print(json)
                                if  json["resultCode"].string == "2000" {
                                    
                                    self.sendCode = "发送成功"
                                    self.sendBtnState = true;
                                }
                            } errorCallback: {
                                self.sendCode = "发送失败"
                            }

                        }, label: {
                            Text(self.sendCode)
                        }).foregroundColor(.gray).disabled(self.sendBtnState)
                        
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom,20)
                }
                .background(Color(red: 1, green: 1, blue: 1, opacity: 0.1))
                .cornerRadius(10)
                .padding(.top,20)
            }
            .padding(.horizontal,20)
            .padding(.top,50)
            .padding(.bottom,30)
                
                Button(action: {
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
                    self.isEdit=false
                    self.isLoading = true
                    self.isModal = true
                    HttpRequest(url: "http://123.207.189.27:7201/login/LoginController/checkPinNumber").doPost(postData: ["\"phoneNum\"" : self.username, "\"pinNumber\"" : self.password]) { (value) in
                        self.isLoading = false
                        self.isModal = false
                        let json = JSON(value)
                        if json["resultCode"].string == "2000" {
                            print("登录成功", json)
                            localConfig.setValue(json["resultEntity"], forKey: "userInfo")
                           NavigationLink(
                            destination: MainView(),
                            label: {
                                /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/
                            })
                        } else {
                            self.startAlert(title: "登录失败", message: "验证码输入错误")

                        }
                      
                    } errorCallback: {
                        print("登录失败")
                        self.isLoading = false
                        self.isModal = false
                        self.startAlert(title: "登录失败", message: "发生了点网络错误")
                    }

                }) {
                    Text("立即登录")
                        .padding(.horizontal,100)
                        .padding(.vertical,15)
                        .font(.system(size:16))
                        .background(Color(red: 1, green: 1, blue: 1, opacity: 0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top,10)
                
                HStack() {
                    Text("登录即默认您已阅读并同意")
                        + Text("《渝北智慧停车用户服务协议》").foregroundColor(.blue)
                        + Text("和")
                        + Text("《渝北智慧停车隐私政策》").foregroundColor(.blue)
                }.padding(.horizontal,20).font(.system(size: 12)).padding(.top)
                
                VStack {
                    Text("其他登录方式").padding(.top,50)
                    Divider()
                    
                    if WXApi.isWXAppInstalled() { Button(action: {
                  
                     let bool =   WXApi.registerApp("wx0bbb4373d8ba4668", universalLink: "https://help.wechat.com/sdksample/")
                    
                        print(bool)
                    
                        let req = SendAuthReq()
                            req.scope = "snsapi_userinfo"
                            req.state = "cqpark_wx_login"
                            WXApi.send(req) { (result) in
                                print(result)
                            }
                        
                       
                    
                        }, label: {
                            Image("login_wechat")
                        })
                    }
                   
                   
                }
        }
            .onTapGesture(perform: {
                self.isEdit = false
                UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
            })
//            .listStyle(GroupedListStyle())
            .preferredColorScheme(.dark)
        }
        .alert(isPresented: $alertShow) {
            Alert(title: Text(alertTitle),message: Text(alertMessage),dismissButton: .default(Text("好的")))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
