package com.walletwise.backend.service;

import com.walletwise.backend.dto.AuthResponse;
import com.walletwise.backend.dto.LoginRequest;
import com.walletwise.backend.dto.RegisterRequest;
import com.walletwise.backend.dto.UpdateProfileRequest;
import com.walletwise.backend.dto.UserResponse;

import com.walletwise.backend.entity.User;
import com.walletwise.backend.mapper.UserMapper;
import com.walletwise.backend.security.JwtService;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.Locale;
import java.util.Set;

@Service
public class AuthService {

    private static final Set<String> SUPPORTED_CURRENCIES =
            Set.of(
                    "USD",
                    "EUR",
                    "GBP",
                    "CNY",
                    "RUB"
            );

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

    public AuthResponse register(
            RegisterRequest request
    ) {
        String username =
                request.username().trim();

        if (userMapper.findByUsername(username) != null) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Username already exists"
            );
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(
                passwordEncoder.encode(
                        request.password()
                )
        );
        user.setEmail(null);
        user.setCurrency(
                normalizeCurrency(
                        request.currency()
                )
        );

        userMapper.insert(user);

        User savedUser =
                getRequiredUserById(user.getId());

        return createAuthResponse(savedUser);
    }

    public AuthResponse login(
            LoginRequest request
    ) {
        String username =
                request.username().trim();

        User user =
                userMapper.findByUsername(username);

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

    public UserResponse getCurrentUser(
            String username
    ) {
        User user =
                getRequiredUserByUsername(username);

        return toUserResponse(user);
    }

    public UserResponse updateCurrentUser(
            String username,
            UpdateProfileRequest request
    ) {
        User user =
                getRequiredUserByUsername(username);

        String normalizedEmail =
                normalizeEmail(request.email());

        String normalizedCurrency =
                normalizeCurrency(
                        request.currency()
                );

        if (normalizedEmail != null) {
            User userWithEmail =
                    userMapper.findByEmail(
                            normalizedEmail
                    );

            if (userWithEmail != null
                    && !userWithEmail
                    .getId()
                    .equals(user.getId())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        "Email is already in use"
                );
            }
        }

        user.setEmail(normalizedEmail);
        user.setCurrency(normalizedCurrency);

        int updatedRows =
                userMapper.updateProfile(user);

        if (updatedRows == 0) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "Profile could not be updated"
            );
        }

        User updatedUser =
                getRequiredUserById(user.getId());

        return toUserResponse(updatedUser);
    }

    private AuthResponse createAuthResponse(
            User user
    ) {
        String token =
                jwtService.generateToken(
                        user.getUsername()
                );

        return new AuthResponse(
                token,
                "Bearer",
                toUserResponse(user)
        );
    }

    private UserResponse toUserResponse(
            User user
    ) {
        return new UserResponse(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getCurrency(),
                user.getCreatedAt()
        );
    }

    private String normalizeEmail(
            String email
    ) {
        if (email == null || email.isBlank()) {
            return null;
        }

        return email
                .trim()
                .toLowerCase(Locale.ROOT);
    }

    private String normalizeCurrency(
            String currency
    ) {
        if (currency == null
                || currency.isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Currency is required"
            );
        }

        String normalizedCurrency =
                currency
                        .trim()
                        .toUpperCase(Locale.ROOT);

        if (!SUPPORTED_CURRENCIES.contains(
                normalizedCurrency
        )) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Unsupported currency"
            );
        }

        return normalizedCurrency;
    }

    private User getRequiredUserByUsername(
            String username
    ) {
        User user =
                userMapper.findByUsername(username);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "User not found"
            );
        }

        return user;
    }

    private User getRequiredUserById(
            Long id
    ) {
        User user =
                userMapper.findById(id);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "User could not be loaded"
            );
        }

        return user;
    }
}