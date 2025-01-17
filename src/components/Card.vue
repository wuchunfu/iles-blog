<!-- eslint-disable vue/no-v-html -->

<template>
  <component
    :is="fold ? 'details' : 'div'"
    :class="['shadow-md rd-1 b-l-6 my-6', boxClasses[type]]"
  >
    <component
      :is="fold ? 'summary' : 'div'"
      :class="['p-3 flex items-center gap-1', fold && 'cursor-pointer']"
    >
      <span :class="['text-5', icon[type]]" />
      <span
        class="font-bold"
        v-html="title || defaultTitle[type]"
      />
      <span
        v-if="fold"
        class="grow flex justify-end"
      >
        <span class="details-icon text-5" />
      </span>
    </component>
    <div class="bg-card dark:bg-bghover overflow-auto px-6 rd-br-1">
      <slot />
    </div>
  </component>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  type?: 'note' | 'info' | 'warn' | 'alert' | 'hint' | 'question';
  fold?: boolean;
  title?: string;
}>(), {
  type: 'note',
  fold: false,
  title: '',
});

const boxClasses = {
  note: 'bg-blue-1 dark:bg-blue-9 b-blue',
  info: 'bg-blue-1 dark:bg-blue-9 b-blue',
  warn: 'bg-orange-1 dark:bg-orange-9 b-orange',
  alert: 'bg-red-1 dark:bg-red-9 b-red-5',
  hint: 'bg-green-2 dark:bg-green-9 b-green-5',
  question: 'bg-purple-2 dark:bg-purple-9 b-purple-5',
};

const defaultTitle = {
  note: 'Note',
  info: 'Info',
  warn: 'Warning',
  alert: 'Alert',
  hint: 'Hint',
  question: 'Question',
};

const icon = {
  note: 'i-mdi-pencil text-blue',
  info: 'i-mdi-info-circle-outline text-blue',
  warn: 'i-mdi-alert-circle-outline text-orange',
  alert: 'i-mdi-alert-outline text-red',
  hint: 'i-mdi-lightbulb-outline text-green',
  question: 'i-mdi-help-circle-outline text-purple',
};
</script>

<style lang="scss" scoped>
details > summary .details-icon {
  @apply i-mdi-chevron-down motion-safe:transition-transform ease-out;
}
details[open] > summary .details-icon {
  @apply scale-y--100;
}

summary::-webkit-details-marker {
  @apply hidden;
}

.shadow-md .shadow-md {
  @apply shadow-lg;
}
</style>
