//
//  ProgramService.swift
//  BrainRush
//
//  Program service
//

import Foundation

@MainActor
class ProgramService: ObservableObject {
    static let shared = ProgramService()
    
    @Published var programs: [Program] = []
    @Published var enrolledPrograms: [Program] = []
    @Published var isLoading = false
    
    private init() {}
    
    func loadPrograms() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let programs: [Program] = try await APIClient.shared.request(
                endpoint: "/mobile/programs",
                method: "GET",
                accessToken: token
            )
            self.programs = programs
        } catch {
            // Handle error
        }
    }
    
    func loadProgramDetails(programId: String) async throws -> Program {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let program: Program = try await APIClient.shared.request(
            endpoint: "/mobile/programs/\(programId)",
            method: "GET",
            accessToken: token
        )
        return program
    }
    
    func enrollInProgram(programId: String) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let _: EmptyResponse = try await APIClient.shared.request(
            endpoint: "/mobile/programs/\(programId)/enroll",
            method: "POST",
            accessToken: token
        )
    }
    
    func loadEnrolledPrograms() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let programs: [Program] = try await APIClient.shared.request(
                endpoint: "/mobile/user/programs",
                method: "GET",
                accessToken: token
            )
            self.enrolledPrograms = programs
        } catch {
            // Handle error
        }
    }
}
