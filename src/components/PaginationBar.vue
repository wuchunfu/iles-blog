<template>
  <nav
    v-if="pageCount > 1"
    class="flex justify-center gap-3 sm:gap-6"
  >
    <a
      :href="hasPrevPage ? `${hrefPrefix}/1` : undefined"
      :class="['sm:hidden btn btn-normal px-1 shrink-0', !hasPrevPage && 'disabled']"
      :aria-disabled="!hasPrevPage"
      aria-label="前往第一页"
    >
      <span class="i-mdi-chevron-double-left" />
    </a>
    <a
      :href="hasPrevPage ? `${hrefPrefix}/${currentPage - 1}` : undefined"
      :class="['btn btn-normal px-1 shrink-0', !hasPrevPage && 'disabled']"
      :aria-disabled="!hasPrevPage"
      aria-label="前往上一页"
    >
      <span class="i-mdi-chevron-left" />
      <span class="mr-1 hidden sm:inline-block">上一页</span>
    </a>
    <div
      class="flex sm:hidden items-center"
      :aria-label="`第${currentPage}页，共${pageCount}页`"
    >
      {{ currentPage }} / {{ pageCount }}
    </div>
    <ol class="hidden sm:flex gap-3 flex-wrap justify-center">
      <li
        v-for="(item, index) of items"
        :key="index"
        :aria-hidden="item.type === 'gap'"
        :class="[
          'flex items-center',
          item.type==='page' && item.largeOnly && 'sm:hidden lg:flex',
          item.type==='gap' && item.smallOnly && 'lg:hidden'
        ]"
      >
        <a
          v-if="item.type === 'page'"
          :class="[
            'btn px-2',
            item.current && 'btn-invert' || 'btn-normal',
          ]"
          :href="`${hrefPrefix}/${item.index}`"
          :aria-current="item.current"
          :aria-label="`第${item.index}页`"
        >
          {{ item.index }}
        </a>
        <span v-else>
          ···
        </span>
      </li>
    </ol>
    <a
      :href="hasNextPage ? `${hrefPrefix}/${currentPage + 1}` : undefined"
      :class="['btn btn-normal px-1 shrink-0', !hasNextPage && 'disabled']"
      :aria-disabled="!hasNextPage"
      aria-label="前往下一页"
    >
      <span class="ml-1 hidden sm:inline-block">下一页</span>
      <span class="i-mdi-chevron-right" />
    </a>
    <a
      :href="hasNextPage ? `${hrefPrefix}/${pageCount}` : undefined"
      :class="['sm:hidden btn btn-normal px-1 shrink-0', !hasNextPage && 'disabled']"
      :aria-disabled="!hasNextPage"
      aria-label="前往最后一页"
    >
      <span class="i-mdi-chevron-double-right" />
    </a>
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = defineProps<{
  currentPage: number;
  pageCount: number;
  hrefPrefix: string;
}>();

type Item = {
  type: 'page';
  index: number;
  largeOnly: boolean;
  current: boolean;
} | {
  type: 'gap';
  smallOnly: boolean;
};

const items = computed(() => {
  const displayPages = Array.from(new Set<number>([
    1,
    2,
    props.currentPage - 2,
    props.currentPage - 1,
    props.currentPage,
    props.currentPage + 1,
    props.currentPage + 2,
    props.pageCount - 1,
    props.pageCount,
  ])).filter((page) => page > 0 && page <= props.pageCount).sort((lhs, rhs) => lhs - rhs);

  const res: Item[] = [];

  displayPages.forEach((page) => {
    let largeOnly = true;
    if (page === 1 || page === props.pageCount) largeOnly = false;
    if (Math.abs(page - props.currentPage) <= 1) largeOnly = false;
    if (res.length) {
      const last = res[res.length - 1];
      if (last.type === 'page') {
        if (page !== last.index + 1) res.push({ type: 'gap', smallOnly: false });
        else {
          for (let i = res.length - 1; i >= 0; i -= 1) {
            const item = res[i];
            if (item.type === 'gap') break;
            if (!item.largeOnly) {
              if (page !== item.index + 1) res.push({ type: 'gap', smallOnly: true });
              break;
            }
          }
        }
      }
    }
    res.push({
      type: 'page',
      index: page,
      largeOnly,
      current: page === props.currentPage,
    });
  });

  return res;
});

const hasPrevPage = computed(() => props.currentPage > 1);
const hasNextPage = computed(() => props.currentPage < props.pageCount);
</script>
