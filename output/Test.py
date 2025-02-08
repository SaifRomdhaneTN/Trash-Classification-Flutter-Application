import torch
import torch.nn as nn
import matplotlib
matplotlib.use('TkAgg')
from torchvision import datasets, models, transforms
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt

import os
import numpy as np



# Test Dataset Importation
test_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

data_dir = 'data'
test_dir = os.path.join(data_dir, 'test')

test_dataset = datasets.ImageFolder(test_dir, transform=test_transform)
test_loader = DataLoader(test_dataset, batch_size=1, shuffle=False)

# Load Model
model = models.resnet50(pretrained=False)
num_ftrs = model.fc.in_features
model.fc = nn.Linear(num_ftrs, 2)
model.load_state_dict(torch.load('resnet50_trash_classifier.pth'))
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
model = model.to(device)
model.eval()


class_names = test_dataset.classes

#accuracy vars
correct = 0
total = 0

predictions = []

for inputs, labels in test_loader:
    inputs, labels = inputs.to(device), labels.to(device)
    outputs = model(inputs)
    _, predicted = torch.max(outputs, 1)

    correct += (predicted == labels).sum().item()
    total += labels.size(0)

    predictions.append((inputs.cpu().squeeze(), class_names[labels.item()], class_names[predicted.item()]))

accuracy = 100 * correct / total
print(f'Accuracy: {accuracy:.2f}%')

# Display images with labels
fig, ax = plt.subplots()

index = 0


def update_display(index):
    ax.clear()
    img, true_label, pred_label = predictions[index]
    img = img.permute(1, 2, 0).numpy()
    img = img * np.array([0.229, 0.224, 0.225]) + np.array([0.485, 0.456, 0.406])  # Denormalize
    img = np.clip(img, 0, 1)

    ax.imshow(img)
    ax.set_title(f'True: {true_label}, Predicted: {pred_label}')
    ax.axis('off')
    fig.canvas.draw()


def on_key(event):
    global index
    if event.key == 'right':
        index = (index + 1) % len(predictions)
        update_display(index)
    elif event.key == 'left':
        index = (index - 1) % len(predictions)
        update_display(index)


update_display(index)
fig.canvas.mpl_connect('key_press_event', on_key)
plt.show()
