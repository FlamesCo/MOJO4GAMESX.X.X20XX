
import pygame
import random

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH, SCREEN_HEIGHT = 800, 600
PADDLE_WIDTH, PADDLE_HEIGHT = 15, 90
BALL_SIZE = 15
PADDLE_SPEED = 7
BALL_SPEED_X, BALL_SPEED_Y = 5, 5

# Set up the drawing window
screen = pygame.display.set_mode([SCREEN_WIDTH, SCREEN_HEIGHT])

# Set up the paddles and ball
player_paddle = pygame.Rect(50, SCREEN_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)
opponent_paddle = pygame.Rect(SCREEN_WIDTH - 50 - PADDLE_WIDTH, SCREEN_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)
ball = pygame.Rect(SCREEN_WIDTH // 2 - BALL_SIZE // 2, SCREEN_HEIGHT // 2 - BALL_SIZE // 2, BALL_SIZE, BALL_SIZE)

# Scoring
player_score = 0
opponent_score = 0
font = pygame.font.Font(None, 74)

# Function to reset the ball
def reset_ball():
    ball.x = SCREEN_WIDTH // 2 - BALL_SIZE // 2
    ball.y = SCREEN_HEIGHT // 2 - BALL_SIZE // 2
    return random.choice((-1, 1)), random.choice((-1, 1))

# Main game loop
running = True
clock = pygame.time.Clock()

while running:
    # Handle events
    for event in pygame.event.get():
        if event.type is pygame.QUIT:
            running = False

    # Move the paddles
    keys = pygame.key.get_pressed()
    if keys[pygame.K_w] and player_paddle.top > 0:
        player_paddle.y -= PADDLE_SPEED
    if keys[pygame.K_s] and player_paddle.bottom < SCREEN_HEIGHT:
        player_paddle.y += PADDLE_SPEED

    # Move the ball
    ball.x += BALL_SPEED_X
    ball.y += BALL_SPEED_Y

    # Ball collision with top and bottom
    if ball.top <= 0 or ball.bottom >= SCREEN_HEIGHT:
        BALL_SPEED_Y *= -1

    # Ball collision with paddles
    if ball.colliderect(player_paddle) or ball.colliderect(opponent_paddle):
        BALL_SPEED_X *= -1

    # Update opponent AI
    if opponent_paddle.centery < ball.centery and opponent_paddle.bottom < SCREEN_HEIGHT:
        opponent_paddle.y += PADDLE_SPEED
    if opponent_paddle.centery > ball.centery and opponent_paddle.top > 0:
        opponent_paddle.y -= PADDLE_SPEED

    # Ball out of bounds
    if ball.left <= 0:
        opponent_score += 1
        BALL_SPEED_X, BALL_SPEED_Y = reset_ball()
    if ball.right >= SCREEN_WIDTH:
        player_score += 1
        BALL_SPEED_X, BALL_SPEED_Y = reset_ball()

    # Fill the background
    screen.fill((0, 0, 0))

    # Draw the paddles and ball
    pygame.draw.rect(screen, (200, 200, 200), player_paddle)
    pygame.draw.rect(screen, (200, 200, 200), opponent_paddle)
    pygame.draw.ellipse(screen, (200, 200, 200), ball)

    # Display the score
    player_text = font.render(str(player_score), True, (200, 200, 200))
    screen.blit(player_text, (32, 24))

    opponent_text = font.render(str(opponent_score), True, (200, 200, 200))
    screen.blit(opponent_text, (SCREEN_WIDTH - 32 - opponent_text.get_width(), 24))

    # Update the display
    pygame.display.flip()

    # Cap the frame rate
    clock.tick(60)

pygame.quit()
