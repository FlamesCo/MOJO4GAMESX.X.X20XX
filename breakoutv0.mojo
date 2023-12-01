import pygame
import sys
import random

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
PADDLE_WIDTH = 100
PADDLE_HEIGHT = 20
PADDLE_SPEED = 10
BALL_RADIUS = 10
BALL_SPEED_X = 5
BALL_SPEED_Y = 5
BRICK_ROWS = 5
BRICK_COLS = 8
BRICK_WIDTH = SCREEN_WIDTH // BRICK_COLS
BRICK_HEIGHT = 30
TARGET_FPS = 60

# Colors
WHITE = (255, 255, 255)
RED = (255, 0, 0)

# Screen setup
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption('Breakout')

# Initialize game objects
paddle_x = (SCREEN_WIDTH - PADDLE_WIDTH) // 2
paddle_y = SCREEN_HEIGHT - PADDLE_HEIGHT - 10
ball_x = SCREEN_WIDTH // 2
ball_y = SCREEN_HEIGHT // 2
ball_speed_x = BALL_SPEED_X * random.choice((1, -1))
ball_speed_y = BALL_SPEED_Y * random.choice((1, -1))

paddle_rect = pygame.Rect(paddle_x, paddle_y, PADDLE_WIDTH, PADDLE_HEIGHT)
ball_rect = pygame.Rect(ball_x - BALL_RADIUS, ball_y - BALL_RADIUS, BALL_RADIUS * 2, BALL_RADIUS * 2)

bricks = [pygame.Rect(x, y, BRICK_WIDTH, BRICK_HEIGHT) for y in range(0, BRICK_HEIGHT * BRICK_ROWS, BRICK_HEIGHT)
          for x in range(0, SCREEN_WIDTH, BRICK_WIDTH)]

# Main game loop
clock = pygame.time.Clock()
running = True

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Player control using 'A' and 'D' keys
    keys = pygame.key.get_pressed()
    if keys[pygame.K_a] and paddle_x > 0:
        paddle_x -= PADDLE_SPEED
    if keys[pygame.K_d] and paddle_x < SCREEN_WIDTH - PADDLE_WIDTH:
        paddle_x += PADDLE_SPEED

    # Update paddle position
    paddle_rect.x = paddle_x

    # Ball movement
    ball_x += ball_speed_x
    ball_y += ball_speed_y
    ball_rect.x = ball_x - BALL_RADIUS
    ball_rect.y = ball_y - BALL_RADIUS

    # Collision with walls
    if ball_x <= BALL_RADIUS or ball_x >= SCREEN_WIDTH - BALL_RADIUS:
        ball_speed_x = -ball_speed_x
    if ball_y <= BALL_RADIUS:
        ball_speed_y = -ball_speed_y

    # Collision with paddle
    if ball_rect.colliderect(paddle_rect):
        ball_speed_y = -ball_speed_y

    # Collision with bricks
    for brick in bricks[:]:
        if ball_rect.colliderect(brick):
            ball_speed_y = -ball_speed_y
            bricks.remove(brick)

    # Game over condition
    if ball_y >= SCREEN_HEIGHT:
        print("Game Over")
        running = False

    # Drawing
    screen.fill((0, 0, 0))
    pygame.draw.rect(screen, WHITE, paddle_rect)
    pygame.draw.circle(screen, WHITE, (ball_x, ball_y), BALL_RADIUS)
    for brick in bricks:
        pygame.draw.rect(screen, RED, brick)

    pygame.display.flip()

    # Frame rate control
    clock.tick(TARGET_FPS)

pygame.quit()
## MOJO GAME DEV 20XX 1.0.0 ##
