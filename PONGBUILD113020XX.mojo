import pygame
import sys
import random

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
PADDLE_WIDTH = 15
PADDLE_HEIGHT = 60
BALL_SIZE = 15
WHITE = (255, 255, 255)
BALL_SPEED = 5
PADDLE_SPEED = 7

# Screen setup
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
pygame.display.set_caption('PONG M1 PORT MOJO EDITION')
font = pygame.font.Font(None, 36)

# Game objects
ball = pygame.Rect(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2, BALL_SIZE, BALL_SIZE)
player_paddle = pygame.Rect(10, SCREEN_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)
ai_paddle = pygame.Rect(SCREEN_WIDTH - 10 - PADDLE_WIDTH, SCREEN_HEIGHT // 2 - PADDLE_HEIGHT // 2, PADDLE_WIDTH, PADDLE_HEIGHT)

ball_speed_x = BALL_SPEED * random.choice((1, -1))
ball_speed_y = BALL_SPEED * random.choice((1, -1))

def ai_movement():
    if ai_paddle.centery < ball.centery:
        ai_paddle.y += min(PADDLE_SPEED, abs(ball.centery - ai_paddle.centery))
    else:
        ai_paddle.y -= min(PADDLE_SPEED, abs(ball.centery - ai_paddle.centery))

# Main loop
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    keys = pygame.key.get_pressed()
    if keys[pygame.K_UP] and player_paddle.top > 0:
        player_paddle.y -= PADDLE_SPEED
    if keys[pygame.K_DOWN] and player_paddle.bottom < SCREEN_HEIGHT:
        player_paddle.y += PADDLE_SPEED

    ai_movement()

    ball.x += ball_speed_x
    ball.y += ball_speed_y

    if ball.top <= 0 or ball.bottom >= SCREEN_HEIGHT:
        ball_speed_y = -ball_speed_y

    if ball.colliderect(player_paddle) or ball.colliderect(ai_paddle):
        ball_speed_x = -ball_speed_x

    if ball.left <= 0 or ball.right >= SCREEN_WIDTH:
        ball.x, ball.y = SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2
        ball_speed_x *= random.choice((1, -1))
        ball_speed_y *= random.choice((1, -1))

    screen.fill((0, 0, 0))
    pygame.draw.ellipse(screen, WHITE, ball)
    pygame.draw.rect(screen, WHITE, player_paddle)
    pygame.draw.rect(screen, WHITE, ai_paddle)

    pygame.display.flip()
    pygame.time.Clock().tick(60)
 
