package com.walletwise.backend.service;

import com.walletwise.backend.dto.AuthResponse;
import com.walletwise.backend.dto.LoginRequest;
import com.walletwise.backend.dto.RegisterRequest;
import com.walletwise.backend.dto.UserResponse;
import com.walletwise.backend.entity.User;
import com.walletwise.backend.mapper.UserMapper;
import com.walletwise.backend.security.JwtService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(
            UserMapper userMapper,
            PasswordEncoder passwordEncoder,
            JwtService jwtService
    ) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public AuthResponse register(RegisterRequest request) {
        String username = request.username().trim();

        if (userMapper.findByUsername(username) != null) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Username already exists"
            );
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(
                passwordEncoder.encode(request.password())
        );

        userMapper.insert(user);

        User savedUser = getRequiredUserById(user.getId());
        return createAuthResponse(savedUser);
    }

    public AuthResponse login(LoginRequest request) {
        String username = request.username().trim();
        User user = userMapper.findByUsername(username);

        if (user == null
                || !passwordEncoder.matches(
                request.password(),
                user.getPassword()
        )) {

            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Invalid username or password"
            );
        }

        return createAuthResponse(user);
    }

    public UserResponse getCurrentUser(String username) {
        User user = userMapper.findByUsername(username);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "User not found"
            );
        }

        return toUserResponse(user);
    }

    private AuthResponse createAuthResponse(User user) {
        String token = jwtService.generateToken(user.getUsername());

        return new AuthResponse(
                token,
                "Bearer",
                toUserResponse(user)
        );
    }

    private UserResponse toUserResponse(User user) {
        return new UserResponse(
                user.getId(),
                user.getUsername(),
                user.getCreatedAt()
        );
    }

    private User getRequiredUserById(Long id) {
        User user = userMapper.findById(id);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Created user could not be loaded"
            );
        }

        return user;
    }
}