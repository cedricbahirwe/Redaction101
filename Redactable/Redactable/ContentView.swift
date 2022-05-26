//
//  ContentView.swift
//  Redactable
//
//  Created by Cédric Bahirwe on 26/05/2022.
//

import SwiftUI

struct ContentView: View {
    let moredeep = Color(#colorLiteral(red: 0.5647058824, green: 0.6392156863, blue: 0.6784313725, alpha: 1))
    let lessdeep = Color(#colorLiteral(red: 0.768627451, green: 0.8039215686, blue: 0.8274509804, alpha: 1))
    @AppStorage("applyRedaction")
    var applyRedaction = false
    var body: some View {
        ZStack {
            Image("sss")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image("manice")
                        .resizable()
                        .frame(maxHeight: .infinity)
                        .cornerRadius(20)
                        .onRedacted(type: .roundedRect(radius: 20, lessdeep))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                applyRedaction.toggle()
                            }
                        }

                    VStack(alignment: .leading) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .padding()
                            .frame(width: 38, height: 38)
                            .background(Material.ultraThinMaterial)
                            .cornerRadius(10)
                            .onRedacted(type: .circle(moredeep))
                        Spacer()
                        Label("Iceland", systemImage: "mappin.and.ellipse")
                            .font(.callout.weight(.semibold))
                            .padding(6)
                            .padding(.horizontal, 5)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
                            .onRedacted(type: .capsule(moredeep))
                        Text("Ice Caves")
                            .font(.title3.bold())
                            .onRedacted(type: .other(shape: AnyView(Capsule().fill(moredeep).frame(height: 16))))
                        Text("$400")
                            .font(.title3.bold())
                            .onRedacted(type: .other(shape: AnyView(Capsule().fill(moredeep).frame(height: 16))))

                    }
                    .foregroundColor(.white)
                    .padding()
                }

                VStack(alignment: .leading) {
                    Text("About the place")
                        .bold()
                        .padding(.vertical, 8)
                        .onRedacted(type: .other(shape: AnyView(Capsule().fill(moredeep).frame(height: 16))))
                    Text("Start an adeventure with a 3-day journey in Iceland and explore the caves")
                        .foregroundStyle(.secondary)
                        .redacted(reason: applyRedaction ? .placeholder : [])
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            itemRow(icon: "clock.fill", title: "Length")
                            itemRow(icon: "person.2.fill", title: "Persons")
                        }

                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            Text("14 days").bold()
                                .onRedacted(type: .other(shape: AnyView(Capsule().fill(moredeep).frame(height: 14))))
                            HStack {
                                btnIcon(icon: "minus")
                                    .onRedacted(type: .circle(moredeep))
                                Text("2").bold()
                                    .onRedacted(type: .circle(lessdeep))
                                btnIcon(icon: "plus")
                                    .onRedacted(type: .circle(moredeep))

                            }
                        }
                    }
                    .padding(.vertical)


                    HStack(spacing: -20) {
                        ForEach(1 ..< 5) { item in
                            Image("cedric\(item)")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .onRedacted(type: .circle(lessdeep))
                                .padding(2)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(radius: 0.2)
                        }
                        Circle().fill(Color(.systemTeal))
                            .overlay(Text("+23").font(.caption.weight(.semibold)))
                            .onRedacted(type: .circle(lessdeep))
                            .frame(width: 40, height: 40)
                            .padding(2)
                            .background(.white)
                            .clipShape(Circle())


                    }
                    .padding(.vertical)

                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("$800").bold()
                                .onRedacted(type: .capsule(moredeep))
                            Text("(2 Tickets)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .leading)
                                .onRedacted(type: .other(shape: AnyView(Capsule().fill(lessdeep).frame(height: 14))))
                        }
                        Spacer()
                        Button {
                            //
                        } label: {
                            Text("Book Now")
                                .bold()
                        }
                        .foregroundColor(.white)
                        .frame(width: 160, height: 40)
                        .background(Color.black)
                        .cornerRadius(12)
                        .onRedacted(type: .roundedRect(radius: 12, moredeep))
                    }


                }
                .padding(5)
                Spacer()
            }
            .padding(10)
            .background(.regularMaterial)
        }
    }

    func itemRow(icon: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .imageScale(.small)
                .foregroundStyle(.secondary)
                .frame(width: 15)
            Text(title)
                .frame(width: 90, alignment: .leading)
                .onRedacted(type: .other(shape: AnyView(Capsule().fill(lessdeep).frame(height: 14))))

        }
        .font(.callout.weight(.semibold))
    }

    func btnIcon(icon: String) -> some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .padding(6)
            .frame(width: 22, height: 22)
            .background(Color.black)
            .cornerRadius(5)
            .foregroundStyle(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


enum RedactionType {
    case circle(_ color: Color?)
    case roundedRect(radius: CGFloat, _ color: Color?)
    case capsule(_ color: Color)
    case other(shape: AnyView)
}


struct OnRedacted: ViewModifier {
    let redactionType: RedactionType
    @AppStorage("applyRedaction")
    private var applyRedaction = false
    init(type: RedactionType) {
        self.redactionType = type
    }

    func body(content: Content) -> some View {
        content
            .opacity(applyRedaction ? 0 : 1)
            .overlay(
                Group{
                    if applyRedaction {
                        getOverlay(redactionType)
                    }
                }
            )
//        if let redactionType = redactionType, applyRedaction {
//            overlayed(content, redactionType)
//        } else {
//            content
//        }
    }

    func overlayed(_ content: Content,_ redactionType: RedactionType) -> some View {
        content
            .opacity(0)
            .background(getOverlay(redactionType))
    }

    func getOverlay(_ redactionType: RedactionType) -> some View {
        Group {
            switch redactionType {
            case .circle(let color):
                Circle().fill(color ?? Color.clear)
            case .roundedRect(let radius, let color):
                RoundedRectangle(cornerRadius: radius).fill(color ?? Color.clear)
            case .capsule(let color):
                Capsule().fill(color)
            case .other(let customOverlay):
                customOverlay
            }
        }
    }
}

extension View {
    func onRedacted(type: RedactionType) -> some View {
        modifier(OnRedacted(type: type))
    }
}
